// ignore_for_file: recursive_getters

import 'package:flutter/material.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItems> products;

  OrderItem({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  final String? authToken;
  final String? userId;
  List<OrderItem> _orders = [];

  Orders(this.authToken, this.userId, this._orders);

  String _isNull = '';
  List<OrderItem> get orders {
    return [..._orders];
  }

  List<OrderItem> get loadedOrders {
    return [...loadedOrders];
  }

  int get ordersLength {
    return _orders.length;
  }

  String get isNulll {
    return _isNull;
  }

  Future<void> fetchAndSetProduct() async {
    final url = Uri.parse(
      'https://shop-app-a058d-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken',
    );
    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>?;
      final List<OrderItem> loadedOrders = [];

      if (extractedData == null) {
        _orders = [];
        _isNull = 'null';
        return;
      }
      _isNull = '';
      extractedData.forEach(
        (orderID, orderData) {
          loadedOrders.add(
            OrderItem(
              id: orderID,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: ((orderData['product'] ?? []) as List<dynamic>)
                  .map(
                    (op) => CartItems(
                      id: op['id'],
                      price: op['price'],
                      quantity: op['quantity'],
                      title: op['title'],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (er) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItems> cartProducts, double total) async {
    final url = Uri.parse(
      'https://shop-app-a058d-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken',
    );
    try {
      final timestamp = DateTime.now();
      final res = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'product': cartProducts
                .map(
                  (cp) => {
                    'creatorId': userId,
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  },
                )
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(res.body)['name'],
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (er) {
      rethrow;
    }
  }
}
