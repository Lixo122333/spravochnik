import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_testapp/user.dart';

class ApiService {
  static const String _baseUrl = 'https://reqres.in/api';
  static String? _token;

  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['token'];
      return _token!;
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users?page=1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List).map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
  
}
