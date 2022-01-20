import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/cart.dart';
import 'package:flutter_shop/providers/product.dart';
import 'package:flutter_shop/providers/product_provider.dart';
import 'package:flutter_shop/screens/cart_screen.dart';
import 'package:flutter_shop/widgets/app_drawer.dart';
import 'package:flutter_shop/widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import 'package:http/http.dart' as http;

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoritesOnly = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    // we put this in InitState because it's the perfect for this use case (showcasing all products from the database)
    // we can use this provider with "listen: false" and this provider would work
    //    Provider.of<ProductProvider>(context, listen: false).fetchAndSetProduct();
    // or option 2, which just lets the widget initialize first before executing this provider of:
    //    Future.delayed(duration.zero).then((_) {
    //      Provider.of<ProductProvider>(contex).fetchAndSetProduct();})
    // or option 3, put this provider in didChangeDependencies since that runs after initState completes.

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping'),
        actions: <Widget>[
          // button which shows an overlay/ dropdown when clicked
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showFavoritesOnly = true;
                } else {
                  // show all items

                  _showFavoritesOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Favorites"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All Products"),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cartData, child) => Badge(
              child: child,
              value: cartData.itemCount.toString(),
              color: Theme.of(context).accentColor,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(showFavoritesOnly: _showFavoritesOnly),
    );
  }
}
