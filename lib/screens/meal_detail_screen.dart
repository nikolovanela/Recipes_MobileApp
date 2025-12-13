import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../models/favorites_manager.dart';
import 'favorites_screen.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final String categoryName;

  MealDetailScreen({required this.mealId, required this.categoryName});

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Meal? _meal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMeal();
  }

  Future<void> loadMeal() async {
    try {
      final meal = await ApiService.getMealDetail(widget.mealId);
      meal.isFavorite = FavoritesManager.instance.isFavorite(meal.id);

      setState(() {
        _meal = meal;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading meal details')),
      );
    }
  }

  void _toggleFavorite() {
    if (_meal == null) return;
    setState(() {
      FavoritesManager.instance.toggleFavorite(_meal!);
      _meal!.isFavorite = !_meal!.isFavorite;
    });
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FavoritesScreen(),
      ),
    );
  }

  void _launchYoutube(String url) async {
    if (url.isEmpty) return;

    String formattedUrl = url;

    if (!formattedUrl.startsWith('http')) {
      formattedUrl = 'https://$formattedUrl';
    }

    if (formattedUrl.contains('youtu.be/')) {
      final id = formattedUrl.split('youtu.be/').last;
      formattedUrl = 'https://www.youtube.com/watch?v=$id';
    }

    final uri = Uri.tryParse(formattedUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open Youtube link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_meal == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('No meal available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_meal!.name),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: _meal!.isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _openFavorites,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              _meal!.thumbnail,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 12),
            Text(
              _meal!.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Category: ${widget.categoryName}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 12),
            Text(
              "Ingredients",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            ..._meal!.ingredients.map((e) {
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
              _meal!.instructions,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),
            if (_meal!.youtube.isNotEmpty)
              ElevatedButton.icon(
                icon: Icon(Icons.video_library),
                label: Text("Watch on YouTube"),
                onPressed: () => _launchYoutube(_meal!.youtube),
              ),
          ],
        ),
      ),
    );
  }
}
