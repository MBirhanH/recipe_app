import 'package:flutter/material.dart';
import 'package:recipe_app/constants/strings.dart';
import 'package:recipe_app/model/recipe_model.dart';
import 'package:recipe_app/model/ui_model.dart';
import 'package:recipe_app/repository/recipes_repo.dart';
import 'package:recipe_app/screens/recipe_details_screen/recipe_details_screen.dart';
import 'package:recipe_app/screens/recipes_list_screen/recipe_card.dart';
import 'package:recipe_app/screens/recipes_list_screen/recipes_list_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class RecipesListScreen extends StatefulWidget {
  const RecipesListScreen({Key? key}) : super(key: key);

  @override
  RecipesListScreenState createState() => RecipesListScreenState();
}

class RecipesListScreenState extends State<RecipesListScreen> {
  final RecipesListViewModel viewModel = RecipesListViewModel(
      Input(BehaviorSubject(), BehaviorSubject(), BehaviorSubject(),
          BehaviorSubject()),
      RecipesRepo());

  // Add a controller to track the search text
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    viewModel.input.fetchRecipes.add(true);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Center(
                  child: TextField(
                    controller: _searchController,
                    textAlignVertical: TextAlignVertical.center,
                    // Add this property
                    decoration: InputDecoration(
                      hintText: AppStrings.inputHint,
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.search, color: Colors.grey[800]),
                      ),
                      border: InputBorder.none,
                      isCollapsed:
                          false,
                    ),
                    onSubmitted: (value) {
                      viewModel.input.searchTapped.add(value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // List title
              StreamBuilder<CombinedRecipeState>(
                stream: viewModel.combinedStream,
                builder: (context, snapshot) {
                  final listType = snapshot.data?.listType ?? ListType.DB;
                  return Text(
                    listType == ListType.DB
                        ? AppStrings.favorites
                        : AppStrings.suggestedRecipes,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<CombinedRecipeState>(
                  stream: viewModel.combinedStream,
                  builder: (context, snapshot) {
                    // Loading state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Error state
                    if (snapshot.hasError ||
                        (snapshot.data?.dbRecipes.state ==
                                OperationState.error &&
                            snapshot.data?.apiRecipes.state ==
                                OperationState.error)) {
                      return const Center(child: Text(AppStrings.geminiError));
                    }

                    final state = snapshot.data ??
                        CombinedRecipeState(UIModel.success([]),
                            UIModel.success([]), ListType.DB);

                    final UIModel<List<Recipe>> currentRecipes =
                        state.listType == ListType.DB
                            ? state.dbRecipes
                            : state.apiRecipes;

                    // Loading
                    if (currentRecipes.state == OperationState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Error
                    if (currentRecipes.state == OperationState.error) {
                      return const Center(child: Text(AppStrings.geminiError));
                    }

                    final recipes = currentRecipes.data ?? [];

                    if (recipes.isEmpty) {
                      return const Center(child: Text(AppStrings.geminiError));
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RecipeDetailsScreen(
                                              recipe: recipes[index],
                                              removeRecipe: () => viewModel
                                                  .input.deleteRecipe
                                                  .add(recipes[index]),
                                              saveRecipe: () => viewModel
                                                  .input.saveRecipe
                                                  .add(recipes[index]),
                                            ))),
                                child: RecipeCard(
                                    removeRecipe: () => viewModel
                                        .input.deleteRecipe
                                        .add(recipes[index]),
                                    saveRecipe: () => viewModel.input.saveRecipe
                                        .add(recipes[index]),
                                    recipe: recipes[index]),
                              );
                            },
                          ),
                        ),
                        // Only show the button when in API mode
                        if (state.listType == ListType.API)
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: SizedBox(
                                width: 205,
                                child: TextButton(
                                  onPressed: () {
                                    // Re-run the search with the current search text
                                    viewModel.input.searchTapped
                                        .add(_searchController.text);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF6052A3),
                                    // Purple color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                  ),
                                  child: const Text(
                                    AppStrings.newResultsButton,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
