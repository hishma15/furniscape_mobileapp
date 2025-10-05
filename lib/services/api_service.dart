import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:furniscapemobileapp/models/category.dart';
import 'package:furniscapemobileapp/models/product.dart';
class ApiService {

  // Initiates Dio for HTTP requests
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));
  // Initiates to save sensitive data
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Base URL to the Laravel backend API
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  // static const String baseUrl = 'http://10.0.2.2:8000/api'; // for Android Emulator
  static const String baseUrl = 'http://ec2-13-217-196-244.compute-1.amazonaws.com/api';


  // Helper method to get token, throws if null
  Future<String> _getToken() async {
    final token = await _storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      throw Exception('No auth token found. User might not be logged in.');
    }
    return token;
  }


  // Sends a post request to the URL by passing the email and password
  Future<bool> login(String email, String password) async {
    try {
      print('Attempting login for $email');
      final response = await _dio.post(
        '$baseUrl/login',
        data: {'email': email, 'password':password},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      // If login is successful, saves the token from the response using FlutterSecureStorage.
      if (response.statusCode == 200 && response.data['token'] != null) {
      //   Save the token Securely
        await _storage.write(key: 'token', value: response.data['token']);
        print('Login successful, token saved.');
        return true;
      }else{
        print('Login failed: Unexpected response.');
        return false;
      }
    }catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required String address,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'phone_no': phone,
          'address': address,
          'role': role,
        },
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['token'] != null) {
        await _storage.write(key: 'token', value: response.data['token']);
        print('Register successful, token saved.');
        return true;
      } else {
        print('Register failed: Unexpected response.');
        return false;
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response?.data;
        print('Register Error Status Code: ${e.response?.statusCode}');
        print('Register Error Data: $data');

        if (data is Map && data.containsKey('errors') && data['errors'].containsKey('email')) {
          final emailErrors = data['errors']['email'] as List<dynamic>;
          final errorMessage = emailErrors.isNotEmpty ? emailErrors[0] : 'Email error';
          print('Email error: $errorMessage');
          // Here, you could throw a custom exception or return a failure with error info
          // e.g. throw Exception(errorMessage);
        }
      } else {
        print('Register Error: $e');
      }
      return false;
    }
  }



  // Removes the token from secure storage to logout the user locally
  Future<void> logout() async {
    await _storage.delete(key: 'token');
    print('User logged out, token removed.');
  }

  // // Reads abd returns the stored token.
  // Future<String?> getToken() async {
  //   return await _storage.read(key: 'token');
  // }

  // Fetch categories
  Future<List<Category>> fetchCategories() async {
    try {
      final token = await _getToken();
      print('Fetching categories with token: $token');

      final response = await _dio.get(
        '$baseUrl/categories',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        print('Categories fetched successfully: ${data.length} items.');
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        print('Failed to fetch categories: ${response.statusCode}');
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Category fetch error: $e');
      rethrow;
    }
  }

//   Fetch products
  Future<List<Product>> fetchAllProducts() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '$baseUrl/products',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];

        print('Raw product JSON: $data');

        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch all products.');
      }
    } catch (e) {
      print('Error fetching all Products: $e');
      rethrow;
    }

  }

//   Fetch user detail
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '$baseUrl/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }

}



//
// Future<bool> login(String email, String password) async {
//   try {
//     print('ApiService: Sending POST to $baseUrl/login with data.');
//     final response = await _dio.post(
//       '$baseUrl/login',
//       data: {'email': email, 'password': password},
//     );
//     print('ApiService: Response code = ${response.statusCode}');
//     print('ApiService: Response body = ${response.data}');
//
//     if (response.statusCode! >= 200 && response.statusCode! < 300) {
//       await _storage.write(key: 'token', value: response.data['token']);
//       return true;
//     } else {
//       print('ApiService: Unexpected status code: ${response.statusCode}');
//       return false;
//     }
//   } on DioException catch (e) {
//     switch (e.type) {
//       case DioExceptionType.connectionTimeout:
//         print('ApiService: Connection Timeout');
//         break;
//       case DioExceptionType.receiveTimeout:
//         print('ApiService: Receive Timeout');
//         break;
//       case DioExceptionType.badResponse:
//         print('ApiService: Bad response: ${e.response?.statusCode} => ${e.response?.data}');
//         break;
//       default:
//         print('ApiService: Other error: ${e.message}');
//     }
//     return false;
//   } catch (e) {
//     print('ApiService: Unexpected error: $e');
//     return false;
//   }
// }

