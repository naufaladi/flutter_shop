import 'package:flutter/material.dart';
import 'package:flutter_shop/widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart' as bruh;
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then(
          (_) => setState(() {
            _isLoading = false;
          }),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (context, index) {
                return bruh.OrderItem(
                  order: orderData.orders[index],
                );
              },
            ),
    );
  }
}
