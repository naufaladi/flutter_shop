import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop/widgets/product_item.dart';
import '../providers/product_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavoritesOnly;
  ProductsGrid({this.showFavoritesOnly});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final productsList =
        showFavoritesOnly ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      itemCount: productsList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        // .value is the method to use if we are just trying to pass a certain value/ list (whenever i reuse an existing object), in other hands, if i want to create a new instance of class object, then i should use without .value
        // (this comment might need to be revised)below is example of using provider in a direct way, as opposed to the example in procuct_item.dart
        // we provide an individual Product provider for each item, so that/ to avoid the case where all product items gets rebuilt even though we only changed one other unrelated product. That, and the fact that the current provider only returns a list (not a single item) and therefore we need to breakdown the list anyway
        return ChangeNotifierProvider.value(
          value: productsList[index],
          child: ProductItem(),
        );
      },
      padding: const EdgeInsets.all(10),
    );
  }
}
