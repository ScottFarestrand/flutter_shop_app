import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _userId != null) {
      print('returning Token $_token');
      return _token;
    }
    return null;
  }

  String get userID {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    // final url =
    // 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyDhZxHvF8t0hwZnXiHPux5jdWDWbfMJftA';
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDhZxHvF8t0hwZnXiHPux5jdWDWbfMJftA';
    print(urlSegment);
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(hours: 24));
      print(responseData);
      print(_token);
      print(_expiryDate);
      if (responseData['error'] != null) {
        print('throwing specific');
        throw HttpException(responseData['error']['message']);
      }
      notifyListeners();
    } catch (error) {
      print('throwing generic');
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}

// import 'package:flutter/widgets.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/http_exception.dart';
//
// class Auth with ChangeNotifier {
//
//   Future<void> _authenticate(String email, String password, String url) async {
//     try {
//       final response = await http.post(
//         url,
//         body: json.encode({
//           'email': email,
//           'password': password,
//           'returnSecureToken': true,
//         }),
//       );
//       print(json.decode(response.body));
//       final responseData = json.decode(response.body);
//       if (responseData['error'] != null) {
//         print('Throwing Message');
//         throw HttpException(responseData['error']['message']);
//       }
//     } catch (error) {}
//   }
//
//   Future<void> login(String email, String password) async {
//     const url =
//         'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDhZxHvF8t0hwZnXiHPux5jdWDWbfMJftA';
//     return _authenticate(email, password, url);
//   }
//
//   Future<void> signup(String email, String password) async {
//     const url =
//         'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDhZxHvF8t0hwZnXiHPux5jdWDWbfMJftA';
//     return _authenticate(email, password, url);
//   }
// }
//
