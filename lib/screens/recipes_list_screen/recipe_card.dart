import 'package:flutter/material.dart';
import 'package:recipe_app/model/recipe_model.dart';
import 'package:rxdart/rxdart.dart';

class RecipeCard extends StatelessWidget {
  final Recipe? recipe;
  final Function saveRecipe;
  final Function removeRecipe;

  const RecipeCard(
      {Key? key,
      required this.recipe,
      required this.saveRecipe,
      required this.removeRecipe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 88,
        child: Row(
          children: [
            Container(
              width: 88,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
              ),
              child: Center(
                child: Icon(Icons.image, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    recipe?.title ?? "",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    recipe?.time ?? "",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => onRecipeTap(),
              child: (recipe?.saved ?? false)
                  ? const Icon(Icons.favorite, size: 24, color: Colors.purple)
                  : const Icon(Icons.favorite_border,
                      size: 24, color: Colors.purple),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  void onRecipeTap() {
    if (recipe?.saved ?? true) {
      removeRecipe();
    } else {
      saveRecipe();
    }
  }
}
