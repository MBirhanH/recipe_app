import 'package:flutter/material.dart';
import 'package:recipe_app/constants/strings.dart';
import 'package:recipe_app/model/recipe_model.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;
  final Function? saveRecipe;
  final Function? removeRecipe;

  const RecipeDetailsScreen({
    super.key,
    required this.recipe,
    this.saveRecipe,
    this.removeRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // Image
                      Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),

                      // Back button
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    recipe.time,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Favorite button
                            InkWell(
                              onTap: () => onRecipeTap(),
                              child: (recipe.saved)
                                  ? const Icon(Icons.favorite, size: 24, color: Colors.purple)
                                  : const Icon(Icons.favorite_border, size: 24, color: Colors.purple),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Ingredients
                        const Text(
                          AppStrings.ingredients,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: recipe.ingredients.map((e) => _buildBulletPoint(e)).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Instructions
                        const Text(
                          AppStrings.instructions,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: recipe.steps.map((e) => _buildNumberedInstruction(
                            recipe.steps.indexOf(e) + 1,
                            e,
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onRecipeTap() {
    if (recipe.saved) {
      removeRecipe?.call();
    } else {
      saveRecipe?.call();
    }
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedInstruction(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$number. ', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}