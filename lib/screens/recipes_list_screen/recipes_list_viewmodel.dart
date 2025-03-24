import 'package:recipe_app/model/recipe_model.dart';
import 'package:recipe_app/model/ui_model.dart';
import 'package:recipe_app/repository/recipes_repo.dart';
import 'package:rxdart/rxdart.dart';

class CombinedRecipeState {
  final UIModel<List<Recipe>> dbRecipes;
  final UIModel<List<Recipe>> apiRecipes;
  final ListType listType;

  CombinedRecipeState(this.dbRecipes, this.apiRecipes, this.listType);
}

class RecipesListViewModel {
  final Input input;
  late Output output;
  RecipesRepo recipesRepo;

  late Stream<CombinedRecipeState> combinedStream;

  List<Recipe> fetchedRecipes = [];
  ListType listType = ListType.DB;

  RecipesListViewModel(this.input, this.recipesRepo) {
    // Stream for DB recipes
    final dbRecipesStream = BehaviorSubject<UIModel<List<Recipe>>>.seeded(UIModel.loading());

    // Stream for API recipes
    final apiRecipesStream = BehaviorSubject<UIModel<List<Recipe>>>.seeded(UIModel.loading());

    // Stream for list type
    final listTypeStream = BehaviorSubject<ListType>.seeded(ListType.DB);

    // Set up the DB operations
    input.fetchRecipes
        .flatMap((value) => recipesRepo.getRecipesDB())
        .listen((event) => dbRecipesStream.add(event));

    input.saveRecipe
        .flatMap((recipe) => recipesRepo.saveRecipeDB(recipe))
        .listen((event) => dbRecipesStream.add(event));

    input.deleteRecipe
        .flatMap((recipe) => recipesRepo.removeRecipeDB(recipe))
        .listen((event) => dbRecipesStream.add(event));

    // API operations
    input.searchTapped
        .flatMap((value) {
      if (value.trim().isEmpty) {
        listTypeStream.add(ListType.DB);
        return recipesRepo.getRecipesDB();
      } else {
        listTypeStream.add(ListType.API);
        return recipesRepo.fetchRecipes(value);
      }
    })
        .map((event) {
      if (listTypeStream.value == ListType.API) {
        fetchedRecipes = event.data ?? [];
      }
      return event;
    })
        .listen((event) {
      if (listTypeStream.value == ListType.DB) {
        dbRecipesStream.add(event);
      } else {
        apiRecipesStream.add(event);
      }
    });

    combinedStream = Rx.combineLatest3<
        UIModel<List<Recipe>>,
        UIModel<List<Recipe>>,
        ListType,
        CombinedRecipeState>(
        dbRecipesStream,
        apiRecipesStream,
        listTypeStream,
            (dbRecipes, apiRecipes, listType) =>
            CombinedRecipeState(dbRecipes, apiRecipes, listType)
    ).asBroadcastStream();

    output = Output(dbRecipesStream, apiRecipesStream, listTypeStream);
  }
}

class Input {
  final BehaviorSubject<String> searchTapped;
  final BehaviorSubject<Recipe> saveRecipe;
  final BehaviorSubject<Recipe> deleteRecipe;
  final BehaviorSubject<bool> fetchRecipes;

  Input(
      this.searchTapped,
      this.saveRecipe,
      this.deleteRecipe,
      this.fetchRecipes,
      );
}

class Output {
  final Stream<UIModel<List<Recipe>>> dbRecipes;
  final Stream<UIModel<List<Recipe>>> apiRecipes;
  final Stream<ListType> listType;

  Output(
      this.dbRecipes,
      this.apiRecipes,
      this.listType,
      );
}

enum ListType { DB, API }