// ignore_for_file: invalid_required_positional_param, prefer_final_fields

import 'package:flutter/foundation.dart';

class CartItems {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItems({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItems> _items = {};
  //we used map to separate bet the cart id and prodId, thats for making easier
  //to change or update the prodItems easily [ex: quantity + 1]

  Map<String, CartItems> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  bool get isCartClear {
    return _items.isEmpty;
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItems(String prodId, String title, double price) {
    if (_items.containsKey(prodId)) {
      _items.update(
        prodId,
        (oldValue) => CartItems(
          id: oldValue.id,
          title: oldValue.title,
          price: oldValue.price,
          quantity: oldValue.quantity + 1,
        ),
      );
    } else {
      // .update or .putIfAbsent is mainly for maps
      _items.putIfAbsent(
        prodId,
        () => CartItems(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String prodId) {
    if (_items[prodId]!.quantity > 1) {
      _items.update(
        prodId,
        (currCartItem) => CartItems(
          id: currCartItem.id,
          title: currCartItem.title,
          price: currCartItem.price,
          quantity: currCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(prodId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
