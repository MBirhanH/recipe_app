class Recipe {
  bool saved;
  final String title;
  final String time;
  final List<String> ingredients;
  final List<String> steps;

  Recipe(
      {this.saved = false,
      required this.title,
      required this.time,
      required this.ingredients,
      required this.steps});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      saved: json['saved'] ?? false,
      title: json['title'],
      time: json['preparation_time'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saved': saved,
      'title': title,
      'preparation_time': time,
      'ingredients': ingredients,
      'steps': steps,
    };
  }
}
