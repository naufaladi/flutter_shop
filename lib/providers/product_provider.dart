import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  // var _showFavoriteOnly = false;

  List<Product> get items {
    // NOTEEE: This strategy (app-wide state) should be used only if u want to have
    // like, more than one product overview pages which will still apply the chosen
    // filters to all those pages (because this product provider only gives a
    // list of items according to the filters set).
    // Here in this app however, we dont want to use app state widget because we dont want to apply the same filters to all product pages, we want to show page which shows the filtered, but also another page which shows all prodcuts for example)
    // TLDR: we typically should manage filtering logics (and similar things)
    //      in spesific widgets, NOTT globally like this commented out codes. We can do this widget-speisifc flitering by using StatefulWidgets in product_overview_screen.dart
    // if (_showFavoriteOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => id == product.id);
  }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProduct() async {
    final url = Uri.parse(
      'https://flutter-bootcamp-8a2fb-default-rtdb.asia-southeast1.firebasedatabase.app/products.json',
    );

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      if (extractedData == null) {
        return;
      }

      extractedData.forEach((keyId, product) {
        loadedProduct.add(
          Product(
            id: keyId,
            title: product['title'],
            description: product['description'],
            price: product['price'],
            imageUrl: product['imageUrl'],
          ),
        );
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
      'https://flutter-bootcamp-8a2fb-default-rtdb.asia-southeast1.firebasedatabase.app/products.json',
    );

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product editedProduct) async {
    final selectedProductIndex = _items.indexWhere((product) => product.id == id);
    if (selectedProductIndex >= 0) {
      final url = Uri.parse(
        'https://flutter-bootcamp-8a2fb-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json',
      );
      await http.patch(
        url,
        body: json.encode(
          {
            'title': editedProduct.title,
            'description': editedProduct.description,
            'price': editedProduct.price,
            'imageUrl': editedProduct.imageUrl,
          },
        ),
      );
      _items[selectedProductIndex] = editedProduct;
      notifyListeners();
    } else {
      print('bruh');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
      'https://flutter-bootcamp-8a2fb-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json',
    );
    final selectedProductIndex = _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[selectedProductIndex];

    //.catchError() here is used to re-add the "deleted" product in case something fails
    // the existingProduct = null is used to tell Dart, in the case that deleting product is successful, that im not interested in this memory data anyomore and u can delete it.

    _items.removeAt(selectedProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(selectedProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Error deleting product');
    }
    existingProduct = null;
  }
}
