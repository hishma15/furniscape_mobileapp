import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/services/api_service.dart';

// Allows widget to listen to thus provider and rebuild when 'notifyListeners()' is called
class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoggedIn = false;  //tracks whether the user logged in

  bool get isLoggedIn => _isLoggedIn; //gettor method

  // Login method
  Future<bool> login(String email, String password) async {
    final success =  await _apiService.login(email, password);
    _isLoggedIn = success;
    return success;
  }


  // Logout method
  Future<void> logout() async {
    await _apiService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}

// Future<bool> login(String email, String password) async {
//   print('AuthProvider: Attempting login for $email');
//   final success = await _apiService.login(email, password);
//   print('AuthProvider: Login result = $success');
//   _isLoggedIn = success;
//   return success;
// }
