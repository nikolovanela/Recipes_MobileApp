class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final String youtube;
  final List<Map<String, String>> ingredients;
  final String category;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.instructions = '',
    this.youtube = '',
    this.ingredients = const [],
    this.category = '',
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> ingredientsList = [];
    for (int i = 1; i <= 20; i++) {
      if (json['strIngredient$i'] != null && json['strIngredient$i'] != '') {
        ingredientsList.add({
          'ingredient': json['strIngredient$i'],
          'measure': json['strMeasure$i'] ?? '',
        });
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      youtube: json['strYoutube'] ?? '',
      category: json['strCategory'] ?? '',
      ingredients: ingredientsList,
    );
  }
}
