class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final String youtube;
  final List<Map<String, String>> ingredients;
  final String category;
  bool isFavorite;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.instructions = '',
    this.youtube = '',
    this.ingredients = const [],
    this.category = '',
    this.isFavorite = false,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'instructions': instructions,
      'youtube': youtube,
      'category': category,
      'ingredients': ingredients,
      'isFavorite': isFavorite,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      instructions: map['instructions'] ?? '',
      youtube: map['youtube'] ?? '',
      category: map['category'] ?? '',
      ingredients: List<Map<String, String>>.from(
        (map['ingredients'] ?? []).map((item) => Map<String, String>.from(item)),
      ),
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}
