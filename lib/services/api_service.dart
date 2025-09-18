import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  // Initiates Dio for HTTP requests
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));
  // Initiates to save sensitive data
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Base URL to the Laravel backend API
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // for Android Emulator


  // Sends a post request to the URL by passing the email and password
  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/login',
        data: {'email': email, 'password':password},
      );

      // If login is successful, saves the token from the response using FlutterSecureStorage.
      if (response.statusCode == 200) {
      //   Save the token Securely
        await _storage.write(key: 'token', value: response.data['token']);
        return true;
      }else{
        return false;
      }
    }catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register({
    // required String firstName,
    // required String lastName,
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required String address,
    required String role,
  }
  ) async {
    try {
      final response =  await _dio.post(
        '$baseUrl/register',
        data: {
          'name' : name,
          'email' : email,
          'password' : password,
          'password_confirmation' : confirmPassword,
          'phone_no' : phone,
          'address' : address,
          'role' : role,
        },

        options: Options(
          headers: {
            'Accept': 'application/json', // To prevent 302
          },
        ),

      );

      final token = response.data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      return true;
    } catch (e) {
      if (e is DioException && e.response != null) {
          print('Register Error Response: ${e.response?.data}');
        } else {
      print('Register Error: $e');
      }
      return false;
      }
  }

  // Removes the token from secure storage to logout the user locally
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  // Reads abd returns the stored token.
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
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

