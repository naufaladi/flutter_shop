import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // ?? as of flutter 2, you dont need to use FocusNode() + focusnode + onfieldSubmitted: FocusScope() to achieve TexInputAction.next. However FocusNode can be useful when you really want to customise how the input form acts, thereforee i still use it/ do it manually here for documentation
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  // this global key will allow us to interact wiht the Form widget
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;

  var _isLoading = false;

  @override
  void dispose() {
    // FocusNode() and Controllers() lingers around even after we quit the screen, therefore we dispose them after we quit the screen to avoid memory leaks
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      Navigator.pop(context);
      _isLoading = false;
    } else {
      Provider.of<ProductProvider>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured'),
            content: Text('Something went wrong: ' + error.toString()),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Okay'),
              )
            ],
          ),
        );
      }).then((value) => Navigator.pop(context));
      _isLoading = false;
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductProvider>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveProduct,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Product Name'),
                      textInputAction: TextInputAction.next,
                      // whenever the right bottom most keyboard button is pressed, change focus to the Price form field. NOTE: see above comment about this not being necesaary for a simple "go to next input form"
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      // below we still use immutable class Product. There is an alternative of creating another Product class which has mutable variables so that we can just update each value instead of recreating a new Product class everytime this runs.
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: value,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This shit is empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_descriptionFocusNode),
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value),
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This shit empty yo';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Numbers only bruh';
                        }
                        if (double.parse(value) <= 0.0) {
                          return 'You givin this out for free?';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: value,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'bruh provide some description pls';
                        }
                        if (value.length < 10) {
                          return 'elaborate!';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 30, right: 15),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            // we need to assign a controller because we want to store/ get the input before it is submitted, so that we can preview the image in the above widget so the user can see it before submitting that image
                            onChanged: (_) {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) => _saveProduct(),
                            controller: _imageUrlController,
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'is empty yo';
                              }
                              if (!value.startsWith('http')) {
                                return 'that\'s not a valid url';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
