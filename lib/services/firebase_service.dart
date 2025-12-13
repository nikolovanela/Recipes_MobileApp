import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  Future<void> toggleFavorite(Meal meal) async {
    final ref = _db.collection('favorites').doc(meal.id);

    if (meal.isFavorite) {
      await ref.delete();
    } else {
      await ref.set(meal.toMap());
    }
  }

  Stream<List<Meal>> getFavorites() {
    return _db.collection('favorites').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Meal.fromMap(doc.data())).toList());
  }

  Future<List<String>> getFavoriteIds() async {
    final snapshot = await _db.collection('favorites').get();
    return snapshot.docs.map((e) => e.id).toList();
  }
}


