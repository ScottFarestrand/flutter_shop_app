import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderFlatButton(cart: cart, scaffoldMessenger: scaffoldMessenger),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderFlatButton extends StatefulWidget {
  const OrderFlatButton({
    Key key,
    @required this.cart,
    @required this.scaffoldMessenger,
  }) : super(key: key);

  final Cart cart;
  final ScaffoldMessengerState scaffoldMessenger;

  @override
  _OrderFlatButtonState createState() => _OrderFlatButtonState();
}

class _OrderFlatButtonState extends State<OrderFlatButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: ( widget.cart.totalAmount <= 0 || _isLoading )? null : () async {
        setState(() {
          _isLoading = true;
        });
        try {
          await Provider.of<Orders>(context, listen: false)
              .addOrder(
            widget.cart.items.values.toList(),
            widget.cart.totalAmount,
          );
          widget.cart.clear();
          setState(() {
            _isLoading = false;
          });
        } catch (error) {
          print('Caught in screen');
          widget.scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                'Error Occurred on Server',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
