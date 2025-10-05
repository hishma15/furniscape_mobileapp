import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/models/product.dart';
import 'package:furniscapemobileapp/models/product.dart';
import 'package:furniscapemobileapp/services/api_service.dart';

class ExploreProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String? _currentCategoryId = 'all';

  List<Product> get allProducts => _allProducts;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get currentCategoryId => _currentCategoryId;

  // Fetch data and filter based on category
  Future<void>loadExploreData({String categoryId = 'all'}) async {
    _isLoading = true;
    _currentCategoryId = categoryId;
    notifyListeners();

    try {
      _allProducts = await _apiService.fetchAllProducts();
      print('Fetched ${_allProducts.length} products');

      if (categoryId == 'all') {
        _filteredProducts = _allProducts;
      } else {
        final int? selectedCategoryId = int.tryParse(categoryId);
        _filteredProducts = _allProducts
            .where((product) => product.categoryId == selectedCategoryId)
            .toList();

        print('Filtering for categoryId: $selectedCategoryId');
        print('Filtered ${_filteredProducts.length} products');

      }
    } catch (e) {
      print('Error loading explore data: $e');
      _filteredProducts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

//   Filter without re-fetching
  void filterByCategory(String categoryId) {
    _currentCategoryId = categoryId;
    if (categoryId == 'all') {
      _filteredProducts = _allProducts;
    } else {
      _filteredProducts = _allProducts
          .where((product) => product.categoryId.toString() == categoryId)
          .toList();
    }
    notifyListeners();
  }


}