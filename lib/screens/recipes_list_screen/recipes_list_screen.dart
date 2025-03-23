import 'package:flutter/material.dart';
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
  final RecipesListViewModel viewModel =
      RecipesListViewModel(Input(PublishSubject()), RecipesRepo());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter ingredients',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (value) => viewModel.input.searchTapped.add(value),
            ),
            const SizedBox(height: 20),
            const Text(
              'Favorites',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<UIModel<List<Recipe>>>(
                stream: viewModel.output.recipes,
                builder: (context, snapshot) {
                  if (snapshot.data?.state == OperationState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data?.state == OperationState.error) {
                    return const Center(child: Text('Error fetching recipes'));
                  }
                  final UIModel<List<Recipe>> recipes =
                      snapshot.data ?? UIModel.success([]);
                  return ListView.builder(
                    itemCount: recipes.data?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => RecipeDetailsScreen(
                                      recipe: recipes.data![index]))),
                          child: RecipeCard(
                              recipe: recipes.data?.elementAt(index)));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
