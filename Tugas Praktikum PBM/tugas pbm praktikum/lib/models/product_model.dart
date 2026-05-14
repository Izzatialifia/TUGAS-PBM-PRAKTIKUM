class ProductModel {
  final int id;
  final String name;
  final double price;
  final String description;
  final String createdAt;
  final String updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  String get formattedPrice {
    final p = price.toInt();
    final s = p.toString();
    final result = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) result.write('.');
      result.write(s[i]);
      count++;
    }
    return 'Rp ${result.toString().split('').reversed.join()}';
  }
}
