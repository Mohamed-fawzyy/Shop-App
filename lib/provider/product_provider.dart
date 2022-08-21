// ignore_for_file: unused_field, prefer_final_fields
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shop_app/provider/product.dart';

import 'product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get isFav {
    return items.where((prod) => prod.isFavorites).toList();
  }

  Product searchById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProduct() async {
    final url = Uri.parse(
      'https://shop-app-a058d-default-rtdb.firebaseio.com/products.json',
    );
    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      //it makes list empty every rebuild to avoid adding same items
      if (extractedData.isEmpty) {
        return;
      }
      extractedData.forEach(
        (prodId, prodData) {
          loadedProduct.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              isFavorites: prodData['isFavorites'],
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
      'https://shop-app-a058d-default-rtdb.firebaseio.com/products.json',
    );
    try {
      final res = await http.post(
        url,
        body: json.encode(
          {
            // converet from data to json
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorites': product.isFavorites,
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
        'https://shop-app-a058d-default-rtdb.firebaseio.com/products/$id.json',
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
      'https://shop-app-a058d-default-rtdb.firebaseio.com/products/$productId.json',
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
