class AppStrings {
  static String geminiPrompt(String ingredients) => """
    Given the following ingredients: $ingredients, provide recipes.
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

  static const String geminiError = "Failed to parse recipes";

  static const String enterIngredients = "Enter ingredients";
  static const String favorites = "Favorites";
  static const String suggestedRecipes = "Suggested Recipes";
  static const String ingredients = "Ingredients:";
  static const String instructions = "Instructions:";
  static const String inputHint = "What do you feel like eating?";
  static const String newResultsButton = "What do you feel like eating?";
}