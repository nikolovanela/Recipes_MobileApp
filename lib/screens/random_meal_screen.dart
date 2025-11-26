import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import 'meal_detail_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Random Meal")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_meal == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Random Meal")),
        body: Center(child: Text("No meal available")),
      );
    }

    return MealDetailScreen(
      mealId: _meal!.id,
      categoryName: _meal!.category,
    );
  }
}
