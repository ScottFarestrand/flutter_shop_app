import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math' as math;
// import 'package:provider/provider.dart';
//
import '../providers/product.dart';
// import '../providers/products.dart';

class ProductEdit extends StatefulWidget {
  static const routeName = 'product-edit';
  final String productId = 'p4';
  // ProductEdit({this.productId});

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  final _priceFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0.9,
    description: '',
    imageUrl: '',
  );

  void _updateImageURL() {
    print('Listner');
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    // final _isInvalid = _form.currentState.validate();
    // print(_isInvalid);
    // if ( _isInvalid ) {
    //   print("darn");
    //   return;
    }
    //
    _form.currentState.save();
    print(_editedProduct.description);
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
    Provider.of<Products>(context, listen:  false).addProduct(_editedProduct);
    Navigator.of(context).pop();
    


  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageURL);
    super.initState();
  }






  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageURL);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _titleFocusNode.dispose();
    _imageURLController.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    // final loadedProduct = Provider.of<Products>(context, listen: false)
    //     .findById(widget.productId);
    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  // validator: (value) {
                  //   if ( value.isEmpty ) {
                  //     return("Title is required");
                  //   }
                  //   return null;
                  // },
                  focusNode: _titleFocusNode,
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,

                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                  // inputFormatters: [
                  //   FilteringTextInputFormatter(RegExp(r'(^[0-9]*(?:\.[0-9]{0,3})?$)'), allow: true)
                  // ],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  focusNode: _priceFocusNode,
                  // validator: (value) {
                  //   if ( value.isEmpty ) {
                  //     return("Please Enter a price");
                  //   }
                  //   if (double.tryParse(value) == null) {
                  //     return 'Please enter a valuid price';
                  //   }
                  //   if (double.parse(value)  <= 0 ) {
                  //     return 'Please enter a price greather than 0';
                  //   }
                  //   return null;
                  // },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 5,
                  textInputAction: TextInputAction.next,
                  // validator: (value) {
                  //   if ( value.isEmpty ) {
                  //     return("Description is required");
                  //   }
                  //   return null;
                  // },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                  },
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: (_imageURLController.text.isEmpty)
                          ? Text('Enter URL')
                          : FittedBox(
                              child: Image.network(_imageURLController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageURLController,
                        focusNode: _imageUrlFocusNode,
                        // validator: (value) {
                        //   if (value.isEmpty) {
                        //     return 'Please enter a image URL';
                        //   }
                        //   return null;
                        // },

                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value,
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}