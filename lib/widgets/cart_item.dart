import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_cart.dart';

class ShoppingCartItem extends StatelessWidget {
  final String id;
  final String productID;
  final double price;
  final int quantity;
  final String title;

  ShoppingCartItem({
    this.id,
    this.productID,
    this.price,
    this.quantity,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: (context),
            builder: (ctx) => AlertDialog(
              title: Text(
                'Confirm Removal',
              ),
              content: Text('Do you want to remove the selected Item?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
              ],
            ),
          );
        }
        // showDialog(context: context, builder: context(ctx) => AlertDialog(title: Text('are you sure'), content: Text('Do you want to remove the selected Item',) ,));
      },
      // direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          Provider.of<Cart>(context, listen: false).removeItem(productID);
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          // child: Row(children: [CircleAvatar(
          //   child: Padding(
          //     padding: EdgeInsets.all(5),
          //     child: FittedBox(
          //       child: Text(
          //         '\$$price',
          //       ),
          //     ),
          //   ),
          // ),Text(title),
          // Text('Total: \$${price * quantity}'),],),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(
                    '\$$price',
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('Quantity $quantity x'),
          ),
        ),
      ),
    );
  }
}
