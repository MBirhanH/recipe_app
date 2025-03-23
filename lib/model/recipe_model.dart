class Recipe {
  final String title;
  final String time;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({required this.title, required this.time, required this.ingredients, required this.steps});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      time: json['preparation_time'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
    );
  }
}