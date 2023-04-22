import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shop_app/provider/product.dart';

class ProductProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;
  ProductProvider(this.authToken, this.userId, this._items);

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get isFav {
    return items.where((prod) => prod.isFavorites).toList();
  }

  Product searchById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

//her a map of all products that add by any usersId but only return the products
//of the singed in to edit his own products.
  String? filterProductsByuserId(Map<String?, dynamic> map, dynamic valueToFind,
      {String parentKey = ''}) {
    for (final key in map.keys) {
      final value = map[key];
      if (value == valueToFind) {
        return parentKey;
      } else if (value is Map<String, dynamic>) {
        final nestedKey =
            filterProductsByuserId(value, valueToFind, parentKey: key!);
        if (nestedKey != null) {
          return nestedKey;
        }
      }
    }
    return null;
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    var url = Uri.parse(
      'https://shop-app-a058d-default-rtdb.firebaseio.com/products.json?auth=$authToken',
    );
    try {
      final res = await http.get(url);
      Map<String?, dynamic> extractedData = json.decode(res.body);
      final List<Product> loadedProduct = [];
      //it makes list empty every rebuild to avoid adding same items
      if (extractedData.isEmpty) {
        return;
      }

      url = Uri.parse(
        'https://shop-app-a058d-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken',
      );
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);

      if (filterByUser) {
        final parentKey = filterProductsByuserId(extractedData, userId);
        final newMap = {parentKey: extractedData[parentKey]};
        extractedData = newMap;
      }

      extractedData.forEach(
        (prodId, prodData) {
          loadedProduct.add(
            Product(
              id: prodId!,
              title: prodData['title'],
              description: prodData['description'],
              // if fav data null make it false bec its a new prod, if prodId is null make fasle
              isFavorites: favData == null ? false : favData[prodId] ?? false,
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
            ),
          );
        },
      );

      _items = loadedProduct;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
      'https://shop-app-a058d-default-rtdb.firebaseio.com/products.json?auth=$authToken',
    );
    try {
      final res = await http.post(
        url,
        body: json.encode(
          {
            // converet from dart to json
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
            'description': product.description,
          },
        ),
      );

      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct); // adding at first of list
      // if u want to added to the last of list, use insert
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (er) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProd) async {
    try {
      final url = Uri.parse(
        'https://shop-app-a058d-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken',
      );
      await http.patch(
        url,
        body: json.encode(
          {
            'description': newProd.description,
            'imageUrl': newProd.imageUrl,
            'price': newProd.price,
            'title': newProd.title,
          },
        ),
      );

      final prodIndex = _items.indexWhere((prod) => prod.id == id);
      _items[prodIndex] = newProd;
      notifyListeners();
    } catch (er) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
      'https://shop-app-a058d-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken',
    );

    Product? existedProduct = items.firstWhere((prod) => prod.id == productId);
    final existedProductIndex = _items.indexOf(existedProduct);
    _items.removeWhere((prod) => prod.id == productId);
    //removeWhere is for list ... remove for map
    notifyListeners();

    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(existedProductIndex, existedProduct);
      notifyListeners();
      throw Exception();
    }
    existedProduct = null;
  }
}
