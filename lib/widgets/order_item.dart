import 'package:flutter/material.dart';
import 'dart:math';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem({@required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.total.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd-MM-yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
            ),
          ),
          if (_expanded)
            Container(
              height:
                  min(widget.order.orderedProducts.length.toDouble() * 20 + 10, 180),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: ListView(
                  children: widget.order.orderedProducts
                      .map(
                        (prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${prod.quantity} x \$${prod.price}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            )
        ],
      ),
    );
  }
}
