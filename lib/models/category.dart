class Category {
  final int id;
  final String name;
  final String? image;

  Category({
    required this.id,
    required this.name,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['category_name'] ?? '',
      image: json['category_image'],
    );
  }
}