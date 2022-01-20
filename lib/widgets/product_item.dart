import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context);

    // note: Consumer<Type>() is a widget, therefore it can be used inside a widget tree to really customize which widget gets rebuild whenever something in the provider data changes. A good use case is when only one object of the same class need to be updated when provder data changes, in such case using Consumer is good(in contrast, Provider.of will rebuild/ re-run the build method)
    // note: child in the builder: of Consumer, can be used to assign a widget(s) which will NOT rebuild when provider changes. Then it will also store that widget tree into "child" argument in builder: so that you can use it in the main widget tree (after the =>)
    // u culd also use both, Provider.of above the widget tree and sets lsiten to false (if the app requires it to), but then maybe one of the child widget below may WANT to listen to changes and rebuilds everytime provider data changes, there we can use Consumer method so only that nested child is rebuild (and listen is true)

    final cart = Provider.of<Cart>(context, listen: false);

    return Consumer<Product>(
      builder: (ctx, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                    context,
                    ProductDetailScreen.routeName,
                    arguments: product.id,
                  ),
              child: Image.network(product.imageUrl, fit: BoxFit.cover)),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon:
                  Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus();
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItemQuantity(product.id);
                      },
                    ),
                    content: Text(
                      'Added ${product.title} to cart',
                      textAlign: TextAlign.start,
                    ),
                    duration: Duration(milliseconds: 2400),
                  ),
                );
              },
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
