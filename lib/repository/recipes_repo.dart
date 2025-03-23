import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recipe_app/model/recipe_model.dart';
import 'package:recipe_app/model/ui_model.dart';
import 'package:recipe_app/utils/gemini_utils.dart';

class RecipesRepo {
  final String apiKey = 'AIzaSyA5IpMW0hi1Za-zKlHE10UA_S1LUGKJxGY';

  Stream<UIModel<List<Recipe>>> fetchRecipes(String ingredients) async* {
    yield UIModel.loading();
    final prompt = """
    Given the following ingredients: $ingredients, provide 3 recipes.
    For each recipe, include the title, preparation time, ingredients (as a list of strings), and steps (as a list of strings).
    Format the response as a JSON array of recipe objects.
    Example:
    [
      {
        "title": "Recipe Title",
        "preparation_time": "Time",
        "ingredients": ["ingredient1", "ingredient2"],
        "steps": ["step1", "step2"]
      }
    ]
  """;
    final response = await http.post(
      Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': prompt
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic>? recipesJson = GeminiUtils.geminiResponseParse(response.body);
      if (recipesJson != null) {
        yield UIModel.success(
            recipesJson.map((json) => Recipe.fromJson(json)).toList());
      } else {
        yield UIModel.error(Exception('Failed to parse recipes'));
      }
    } else {
      yield UIModel.error(Exception('Failed to parse recipes'));
    }
  }
}
