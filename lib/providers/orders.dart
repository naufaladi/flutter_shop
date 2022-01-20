import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter_shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double total;
  final List<CartItem> orderedProducts;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.total,
    @required this.orderedProducts,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
      'https://flutter-bootcamp-8a2fb-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json',
    );

    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = await json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) async {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          total: orderData['total'],
          dateTime: DateTime.parse(orderData['dateTime']),
          orderedProducts: (orderData['orderedProducts'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
        ),
      );
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
      'https://flutter-bootcamp-8a2fb-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json',
    );

    final timeStamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'total': total,
          'orderedProducts': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
          'dateTime': timeStamp.toIso8601String(),
        }));

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        total: total,
        orderedProducts: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
