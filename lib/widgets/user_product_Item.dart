import 'package:flutter/material.dart';
import '../screens/product_edits.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageURl;
  final double price;

  UserProductItem({this.title, this.imageURl, this.price});

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
                  Navigator.of(context).pushNamed(ProductEdit.routeName);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(ProductEdit.routeName);
                },
              )
            ],
          ),
        ));
  }
}
