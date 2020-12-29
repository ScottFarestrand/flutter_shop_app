import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../providers/cart.dart';

import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shopapp-ab5a0-default-rtdb.firebaseio.com/orders.json';
    final orderDateTime = DateTime.now();
    var orderId;
    print("Posting");
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'dateTime': orderDateTime.toString(),
          'amount': total,
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList()
        }),
      );
      final statusCode = response.statusCode;
      print('Status Code $statusCode');
      orderId = json.decode(response.body)['name'];
      print(orderId);
      if (response.statusCode >= 400) {
        print('throw');
        throw HttpException('Error while trying to store order');
      }
      orders.insert(
        0,
        OrderItem(
          id: orderId,
          amount: total,
          dateTime: orderDateTime,
          products: cartProducts,
        ),
      );
    } catch (error) {
      print('Caught');
      print('Error $error');
      throw HttpException((error));
    }

    notifyListeners();
  }
}
