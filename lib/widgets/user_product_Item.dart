import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../screens/product_edits.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageURl;
  final double price;

  UserProductItem({this.id, this.title, this.imageURl, this.price});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageURl),
        ),
        trailing: Container(
          width: 150,
          child: Row(
            children: <Widget>[
              Text('\$$price'),
              IconButton(
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  print(ProductEdit.routeName);
                  Navigator.of(context)
                      .pushNamed(ProductEdit.routeName, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  print('deleting');
                  print(id);
                  Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                  // Navigator.of(context).pushNamed(ProductEdit.routeName);
                },
              )
            ],
          ),
        ));
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
