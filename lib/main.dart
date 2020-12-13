import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_details.dart';
import './screens/product_overview.dart';
import './screens/shopping_cart.dart';
import './screens/orders_list.dart';
import './screens/user_products.dart';
import './screens/product_edits.dart';

import './providers/products.dart';
import './providers/shopping_cart.dart';
import './providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverview(),
        routes: {
          ProductDetails.routeName: (ctx) => ProductDetails(),
          ShoppingCart.routeName: (ctx) => ShoppingCart(),
          OrdersList.routeName: (ctx) => OrdersList(),
          UserProducts.routeName: (ctx) => UserProducts(),
          ProductEdit.routeName: (ctx) => ProductEdit(),
        },
      ),
    );
  }
}
