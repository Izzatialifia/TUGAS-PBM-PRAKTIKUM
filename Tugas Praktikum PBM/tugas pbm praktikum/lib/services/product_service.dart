import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'auth_service.dart';

class ProductService {
  static const String baseUrl = 'https://task.itprojects.web.id';

  static Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<ProductModel>> getProducts() async {
    final url = Uri.parse('$baseUrl/api/products');
    final response = await http.get(url, headers: await _authHeaders());
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final List list = data['data']['products'];
      return list.map((e) => ProductModel.fromJson(e)).toList();
    }
    throw Exception(data['message'] ?? 'Gagal mengambil produk');
  }

  static Future<Map<String, dynamic>> addProduct({
    required String name,
    required int price,
    required String description,
  }) async {
    final url = Uri.parse('$baseUrl/api/products');
    final response = await http.post(
      url,
      headers: await _authHeaders(),
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );
    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 201 || data['success'] == true,
      'message': data['message'] ?? '',
    };
  }

  static Future<Map<String, dynamic>> deleteProduct(int id) async {
    final url = Uri.parse('$baseUrl/api/products/$id');
    final response = await http.delete(url, headers: await _authHeaders());
    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200 && data['success'] == true,
      'message': data['message'] ?? '',
    };
  }

  static Future<Map<String, dynamic>> submitTugas({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    final url = Uri.parse('$baseUrl/api/products/submit');
    final response = await http.post(
      url,
      headers: await _authHeaders(),
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl,
      }),
    );
    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 201 || data['success'] == true,
      'message': data['message'] ?? '',
    };
  }
}
