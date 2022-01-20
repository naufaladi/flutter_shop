import 'package:flutter/material.dart';
import 'package:flutter_shop/screens/orders_screen.dart';
import 'package:flutter_shop/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text("Hello frendo"),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop_2),
          title: Text('Shop'),
          onTap: () => Navigator.pushReplacementNamed(context, '/'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shopping_cart),
          title: Text('Orders'),
          onTap: () =>
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: () =>
              Navigator.pushReplacementNamed(context, UserProductsScreen.routeName),
        ),
      ]),
    );
  }
}
