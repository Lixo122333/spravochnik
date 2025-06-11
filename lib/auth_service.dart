import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'https://reqres.in/api';

  static Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return data['token'] as String;
      } else {
        throw Exception(data['error'] ?? 'Ошибка авторизации');
      }
    } catch (e) {
      throw Exception('Ошибка сети: ${e.toString()}');
    }
  }
}