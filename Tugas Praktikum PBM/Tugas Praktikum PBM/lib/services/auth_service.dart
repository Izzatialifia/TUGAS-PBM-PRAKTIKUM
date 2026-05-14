import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://task.itprojects.web.id';
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> login(String nim, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': nim,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final token = data['data']['token'];
      final user = UserModel.fromJson(data['data']['user']);
      await _storage.write(key: 'token', value: token);
      await _storage.write(key: 'user_name', value: user.name);
      await _storage.write(key: 'user_nim', value: user.username);
      return {'success': true, 'user': user, 'token': token};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Login gagal'};
    }
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<String?> getUserName() async {
    return await _storage.read(key: 'user_name');
  }

  static Future<String?> getUserNim() async {
    return await _storage.read(key: 'user_nim');
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    return token != null && token.isNotEmpty;
  }
}
