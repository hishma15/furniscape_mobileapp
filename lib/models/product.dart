class Product {
  final int id;
  final String name;
  final String? image;
  final double price;
  final String description;
  final int stock;
  final bool isFeatured;
  final int? categoryId;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.stock,
    required this.isFeatured,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id:  json['id'],
      name: json['product_name'],
      image: json['product_image'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      stock: json['no_of_stock'] ?? 0,
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      categoryId: json['category'] != null ? json['category']['id'] : null,
    );
  }

}