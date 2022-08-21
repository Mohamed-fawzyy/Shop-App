import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorites;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorites = false,
  });

  void _setFavValue(bool newValue) {
    isFavorites = newValue;
    notifyListeners();
  }

  Future<void> favStatus() async {
    final oldStatus = isFavorites;
    isFavorites = !isFavorites;
    notifyListeners();
    final url = Uri.parse(
      'https://shop-app-a058d-default-rtdb.firebaseio.com/products/$id.json',
    );
    try {
      final res = await http.patch(
        url,
        body: json.encode(
          {
            'isFavorites': isFavorites,
          },
        ),
      );

      if (res.statusCode >= 400) {
        _setFavValue(oldStatus);
        throw Exception();
      }
    } catch (er) {
      _setFavValue(oldStatus);
      rethrow;
    }
  }
}
