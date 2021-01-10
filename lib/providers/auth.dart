import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

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
      print('Starting Timer');
      _autoLogout();
      notifyListeners();
      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      preferences.setString('userData', userData);
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

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      final userData =
          json.decode(preferences.getString('userData')) as Map<String, Object>;
      final expiryDate = DateTime.parse(userData['expiryDate']);
      print(expiryDate);
      if (expiryDate.isBefore(DateTime.now())) {
        print('expired');
        return false;
      } else {
        print('nokey');
      }
      _token = userData['token'];
      _userId = userData['userId'];
      _expiryDate = userData['expiryDate'];
      notifyListeners();
      _autoLogout();
      print('true');
      return true;
    }
    return false;
  }

  void logout() {
    print('logging out');
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final _secondsToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _secondsToExpiry), logout);
  }
}
