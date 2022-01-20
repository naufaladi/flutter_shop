import 'package:flutter/material.dart';
import 'package:flutter_shop/screens/edit_product_screen.dart';
import 'package:flutter_shop/widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _refreshProduct(context);
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (ctx, i) {
              return Column(
                children: [
                  UserProductItem(
                    productsData.items[i].title,
                    productsData.items[i].imageUrl,
                    productsData.items[i].id,
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
