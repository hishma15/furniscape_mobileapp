import 'package:flutter/foundation.dart';
import 'package:furniscapemobileapp/models/cartitem.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get subTotal {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

//   Delivery fee and tax fixed values
  double get deliveryFee => 15000.0;
  double get tax => 32000.0;

  double get totalAmount => subTotal + deliveryFee + tax;

  void addItem(String productId,  String title, double price, String imageUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
          (existing) =>CartItem(
            id: existing.id,
            productId: existing.productId,
            title: existing.title,
            price: existing.price,
            quantity: existing.quantity + 1,
            imageUrl: existing.imageUrl
          ),
      );
    } else {
      _items.putIfAbsent(
        productId,
            () => CartItem(
            id: DateTime.now().toString(),
            productId: productId,
            title: title,
            price: price,
            quantity: 1,
            imageUrl: imageUrl,
          ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    if(!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
              (existing) => CartItem(
            id: existing.id,
            productId: existing.productId,
            title: existing.title,
            price: existing.price,
            quantity: existing.quantity - 1,
            imageUrl: existing.imageUrl,
          )
      );
    } else {
      removeItem(productId);
    }
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    _items.update(
        productId,
            (existing) => CartItem(
          id: existing.id,
          productId: existing.productId,
          title: existing.title,
          price: existing.price,
          quantity: existing.quantity + 1,
          imageUrl: existing.imageUrl,
        ));
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

}