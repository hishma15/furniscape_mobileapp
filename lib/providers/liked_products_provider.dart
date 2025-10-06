import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikedProductsProvider with ChangeNotifier {
  Set<int> _likedProductIds = {};

  LikedProductsProvider() {
    _loadLikedProducts();
  }

  Set<int> get likedProductIds => _likedProductIds;

  bool isLiked(int productId) => _likedProductIds.contains(productId);

  Future<void> toggleLike(int productId) async {
    if (_likedProductIds.contains(productId)) {
      _likedProductIds.remove(productId);
    } else {
      _likedProductIds.add(productId);
    }
    notifyListeners();
    await _saveLikedProducts();
  }

  Future<void> _loadLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final likedIds = prefs.getStringList('likedProducts') ?? [];
    _likedProductIds = likedIds.map(int.parse).toSet();
    notifyListeners();
  }

  Future<void> _saveLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('likedProducts', _likedProductIds.map((id) => id.toString()).toList());
  }
}

