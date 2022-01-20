import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/cart.dart' show Cart;
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/cart_item.dart'; // can also add "as 'something'" here in case we have Class with same name between two files or more

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Price',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      ('\$' + cart.totalCartPrice.toStringAsFixed(2)),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, index) {
                var cartMapToList = cart.items.values.toList();
                return CartItem(
                  productId: cart.items.keys.toList()[index],
                  id: cartMapToList[index].id,
                  title: cartMapToList[index].title,
                  quantity: cartMapToList[index].quantity,
                  price: cartMapToList[index].price,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalCartPrice <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalCartPrice,
              );
              widget.cart.clearCart();
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
    );
  }
}
