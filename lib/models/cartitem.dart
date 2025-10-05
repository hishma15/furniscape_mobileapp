class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  int quantity;
  final String imageUrl;

  CartItem ({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    this.quantity = 1,
    required this.imageUrl,
  });
}