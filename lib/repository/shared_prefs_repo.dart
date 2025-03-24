import 'dart:convert';

import 'package:recipe_app/repository/dependencies_factory.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/recipe_model.dart';

class SharedPrefRepo {
  final DependenciesFactory dependenciesFactory;

  SharedPrefRepo({DependenciesFactory? dependenciesFactory})
      : dependenciesFactory =
            dependenciesFactory ?? DependenciesHelper.dependenciesFactory();

  Stream<SharedPreferences> _initSharedPreferences() {
    return dependenciesFactory.sharedPreferences();
  }

  Stream<List<Recipe>> getRecipes() {
    return _initSharedPreferences().map((sharedPreferences) {
      List<String>? recipeListString =
          sharedPreferences.getStringList('recipes');
      return recipeListString
              ?.map((recipe) => Recipe.fromJson(jsonDecode(recipe)))
              .toList() ??
          [];
    });
  }

  Stream<bool> saveRecipes(List<Recipe> recipes) {
    return _initSharedPreferences().flatMap((sharedPreferences) {
      List<String> recipeList =
          recipes.map((recipe) => jsonEncode(recipe.toJson())).toList();
      return sharedPreferences.setStringList('recipes', recipeList).asStream();
    });
  }
}
