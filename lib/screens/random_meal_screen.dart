import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../models/favorites_manager.dart';
import 'favorites_screen.dart';

class RandomMealScreen extends StatefulWidget {
  @override
  _RandomMealScreenState createState() => _RandomMealScreenState();
}

class _RandomMealScreenState extends State<RandomMealScreen> {
  Meal? _meal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRandomMeal();
  }

  Future<void> loadRandomMeal() async {
    try {
      final meal = await ApiService.getRandomMeal();
      meal.isFavorite = FavoritesManager.instance.isFavorite(meal.id);

      setState(() {
        _meal = meal;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading random meal')),
      );
    }
  }

  void toggleFavorite() {
    if (_meal == null) return;
    setState(() {
      FavoritesManager.instance.toggleFavorite(_meal!);
      _meal!.isFavorite = !_meal!.isFavorite;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random Meal"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            color: _meal != null && _meal!.isFavorite ? Colors.red : null,
            onPressed: toggleFavorite,
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: openFavorites,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _meal == null
          ? Center(child: Text("No meal available"))
          : SingleChildScrollView(
        child: MealDetailContent(meal: _meal!),
      ),
    );
  }
}

class MealDetailContent extends StatelessWidget {
  final Meal meal;

  MealDetailContent({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            meal.thumbnail,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 12),
          Text(
            meal.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Category: ${meal.category}',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 12),
          Text(
            "Ingredients",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          ...meal.ingredients.map((e) {
            final ingredient = e['ingredient'] ?? '';
            final measure = e['measure'] ?? '';
            if (ingredient.trim().isEmpty) return SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Text(
                "- $ingredient (${measure.isNotEmpty ? measure : '-'})",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),
            );
          }).toList(),
          SizedBox(height: 12),
          Text(
            "Instructions",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            meal.instructions,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}
