import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String productName;
  final String imageUrl;
  final String id;

  UserProductItem(this.productName, this.imageUrl, this.id);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(productName),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  EditProductScreen.routeName,
                  arguments: id,
                );
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () async {
                try {
                  await Provider.of<ProductProvider>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                      SnackBar(content: Text('Error deleting product')));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
