import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/http_exception.dart';


class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userID) async {
    // final id = this.id
    print(id);
    final url = 'https://shopapp-ab5a0-default-rtdb.firebaseio.com/favorites/$userID/$id.json?auth=$authToken';
    print(url);
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        print(response.body);
        print('throwing');
        isFavorite = !isFavorite;
        notifyListeners();
        throw HttpException('Could not toggle Favorite');
      }
    }
    catch (error){
    isFavorite = !isFavorite;
    print(error);
    throw HttpException(error);
        }

  }
}

