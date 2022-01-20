import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String id;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    this.productId,
    this.id,
    this.price,
    this.quantity,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('This will remove the item from the cart'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text('Nevermind'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text('Yes'),
                  ),
                ],
              );
            });
      },
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (direction) {
        //direction here is to give us option for each different dismiss direction, incase we implemented different function for each direction (not the case here)
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Container(
                padding: EdgeInsets.all(3),
                child: FittedBox(
                  child: Text('\$' + price.toStringAsFixed(2)),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Sub-total: \$' + (price * quantity).toStringAsFixed(2)),
            trailing: Text(quantity.toString() + 'x'),
          ),
        ),
      ),
    );
  }
}
