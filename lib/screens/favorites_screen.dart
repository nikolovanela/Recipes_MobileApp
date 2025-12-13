import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../widgets/meal_card.dart';
import '../models/favorites_manager.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesManager.instance.favorites;

    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: favorites.isEmpty
          ? Center(child: Text('No favorite meals yet.'))
          : GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: favorites.length,
        itemBuilder: (ctx, index) {
          final meal = favorites[index];
          return MealCard(
            meal: meal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(
                    mealId: meal.id,
                    categoryName: meal.category,
                  ),
                ),
              );
            },
            onFavoriteToggle: () {
              setState(() {
                FavoritesManager.instance.toggleFavorite(meal);
                meal.isFavorite = false;
              });
            },
          );
        },
      ),
    );
  }
}
