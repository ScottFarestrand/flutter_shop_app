// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/user_product_Item.dart';
import '../widgets/app_drawer.dart';

import '../screens/product_edits.dart';

import '../providers/products.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/userProducts';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getProducts();
  }
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Product Listing'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(ProductEdit.routeName);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) => Column(children: [
              UserProductItem(
                id: productsData.items[i].id,
                title: productsData.items[i].title,
                imageURl: productsData.items[i].imageUrl,
                price: productsData.items[i].price,
              ),
              Divider(),
            ]),
          ),
        ),
      ),
    );
  }
}
