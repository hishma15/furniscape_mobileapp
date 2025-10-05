import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/models/category.dart';
import 'package:furniscapemobileapp/models/product.dart';
import 'package:furniscapemobileapp/services/api_service.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Category> _categories = [];
  List<Product> _featuredProducts = [];
  bool _isLoading = true;

  List<Category> get categories => _categories;
  List<Product> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;

  Future<void> loadHomeData() async {
    _isLoading = true;
    notifyListeners();

    try{
      _categories = await _apiService.fetchCategories();

      final allProducts = await _apiService.fetchAllProducts();
      _featuredProducts = allProducts.where((product) => product.isFeatured).toList();

    } catch (e) {
      print('Error loading home data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

}