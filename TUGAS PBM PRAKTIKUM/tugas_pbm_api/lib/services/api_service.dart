import 'dart:convert';
import 'package:http/http.dart'
    as http;

import '../models/product_model.dart';
import 'storage_service.dart';

class ApiService {
  static const String baseUrl =
      'https://task.itprojects.web.id';

  // LOGIN
  static Future<bool> login(
    String username,
    String password,
  ) async {
    final url = Uri.parse(
      '$baseUrl/api/auth/login',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type':
            'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data =
          jsonDecode(response.body);

      String token =
          data['data']['token'];

      await StorageService.saveToken(
        token,
      );

      return true;
    }

    return false;
  }

  // GET PRODUCTS
  static Future<List<Product>>
      getProducts() async {
    String? token =
        await StorageService.getToken();

    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/products',
      ),
      headers: {
        'Authorization':
            'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data =
          jsonDecode(response.body);

      return List<Product>.from(
        data['data'].map(
          (x) => Product.fromJson(x),
        ),
      );
    }

    return [];
  }

  // ADD PRODUCT
  static Future<bool> addProduct(
    Product product,
  ) async {
    String? token =
        await StorageService.getToken();

    final response = await http.post(
      Uri.parse(
        '$baseUrl/api/products',
      ),
      headers: {
        'Authorization':
            'Bearer $token',
        'Content-Type':
            'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(
        product.toJson(),
      ),
    );

    return response.statusCode ==
            200 ||
        response.statusCode == 201;
  }

  // SUBMIT TUGAS
  static Future<bool> submitTask({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    String? token =
        await StorageService.getToken();

    final response = await http.post(
      Uri.parse(
        '$baseUrl/api/products/submit',
      ),
      headers: {
        'Authorization':
            'Bearer $token',
        'Content-Type':
            'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description':
            description,
        'github_url':
            githubUrl,
      }),
    );

    return response.statusCode ==
        200;
  }
}