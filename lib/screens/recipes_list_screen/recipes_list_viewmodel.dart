import 'package:recipe_app/model/recipe_model.dart';
import 'package:recipe_app/model/ui_model.dart';
import 'package:recipe_app/repository/recipes_repo.dart';
import 'package:rxdart/rxdart.dart';

class RecipesListViewModel {
  final Input input;
  late Output output;
  RecipesRepo recipesRepo;

  RecipesListViewModel(this.input, this.recipesRepo) {

    Stream<UIModel<List<Recipe>>> recipesList = input.searchTapped.flatMap((value) => recipesRepo.fetchRecipes(value));
    output = Output(recipesList);
}
}


class Input {
  final PublishSubject<String> searchTapped;

  Input(
      this.searchTapped,
      );
}

class Output {
  final Stream<UIModel<List<Recipe>>> recipes;

  Output(
      this.recipes,
      );
}