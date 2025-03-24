import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recipe_app/constants/strings.dart';
import 'package:recipe_app/model/recipe_model.dart';
import 'package:recipe_app/model/ui_model.dart';
import 'package:recipe_app/repository/dependencies_factory.dart';
import 'package:recipe_app/repository/shared_prefs_repo.dart';
import 'package:recipe_app/utils/gemini_utils.dart';
import 'package:rxdart/rxdart.dart';

class RecipesRepo {
  late SharedPrefRepo sharedPrefRepo;
  late RepoFactory repoFactory;
  final DependenciesFactory dependenciesFactory;

  RecipesRepo({
    DependenciesFactory? dependenciesFactory,
  }) : dependenciesFactory =
            dependenciesFactory ?? DependenciesHelper.dependenciesFactory() {
    repoFactory = this.dependenciesFactory.repoFactory();
    sharedPrefRepo = repoFactory.sharedPrefRepo();
  }

  final String apiKey = 'AIzaSyA5IpMW0hi1Za-zKlHE10UA_S1LUGKJxGY';
  final String geminiURL =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=";

  Stream<UIModel<List<Recipe>>> fetchRecipes(String ingredients) async* {
    yield UIModel.loading();
    final prompt = AppStrings.geminiPrompt(ingredients);
    final response = await http.post(
      Uri.parse(geminiURL + apiKey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic>? recipesJson =
          GeminiUtils.geminiResponseParse(response.body);
      if (recipesJson != null) {
        yield UIModel.success(
            recipesJson.map((json) => Recipe.fromJson(json)).toList());
      } else {
        yield UIModel.error(Exception(AppStrings.geminiError));
      }
    } else {
      yield UIModel.error(Exception(AppStrings.geminiError));
    }
  }

  Stream<UIModel<List<Recipe>>> saveRecipeDB(Recipe recipe) {
    return sharedPrefRepo.getRecipes().flatMap((recipes) {
      recipe.saved = true;
      recipes.add(recipe);
      return sharedPrefRepo
          .saveRecipes(recipes)
          .map((event) => UIModel.success(recipes));
    });
  }

  Stream<UIModel<List<Recipe>>> removeRecipeDB(Recipe recipe) {
    return sharedPrefRepo.getRecipes().flatMap((recipes) {
      recipes.removeWhere((element) => element.title == recipe.title);
      return sharedPrefRepo
          .saveRecipes(recipes)
          .map((event) => UIModel.success(recipes));
    });
  }

  Stream<UIModel<List<Recipe>>> getRecipesDB() {
    return sharedPrefRepo.getRecipes().map((recipes) {
      for (var e in recipes) {
        e.saved = true;
      }
      return UIModel.success(recipes);
    });
  }
}
