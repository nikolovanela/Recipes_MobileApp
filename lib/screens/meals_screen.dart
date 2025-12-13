import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';
import 'favorites_screen.dart';
import '../models/favorites_manager.dart';

class MealsScreen extends StatefulWidget {
  final String categoryName;

  MealsScreen({required this.categoryName});

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<Meal> _meals = [];
  List<Meal> _filtered = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final data = await ApiService.getMealsByCategory(widget.categoryName);

    for (var meal in data) {
      meal.isFavorite = FavoritesManager.instance.isFavorite(meal.id);
    }

    setState(() {
      _meals = data;
      _filtered = data;
      _isLoading = false;
    });
  }

  void filterMeals(String query) {
    setState(() {
      _filtered = _meals
          .where((meal) => meal.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FavoritesScreen(),
      ),
    );
  }


  void toggleFavorite(Meal meal) {
    setState(() {
      FavoritesManager.instance.toggleFavorite(meal);
      meal.isFavorite = !meal.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: openFavorites,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search meals...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterMeals,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _filtered.length,
              itemBuilder: (ctx, index) {
                final meal = _filtered[index];
                return MealCard(
                  meal: meal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailScreen(
                          mealId: meal.id,
                          categoryName: widget.categoryName,
                        ),
                      ),
                    );
                  },
                  onFavoriteToggle: () => toggleFavorite(meal),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
