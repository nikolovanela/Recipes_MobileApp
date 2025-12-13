import '../models/meal.dart';

class FavoritesManager {
  FavoritesManager._privateConstructor();
  static final FavoritesManager instance = FavoritesManager._privateConstructor();

  final List<Meal> _favorites = [];

  List<Meal> get favorites => _favorites;

  void toggleFavorite(Meal meal) {
    if (isFavorite(meal.id)) {
      _favorites.removeWhere((m) => m.id == meal.id);
    } else {
      _favorites.add(meal);
    }
  }

  bool isFavorite(String mealId) {
    return _favorites.any((m) => m.id == mealId);
  }
}
