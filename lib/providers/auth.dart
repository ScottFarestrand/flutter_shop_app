import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {


  Future<void> _authenticate(String email, String password, String url) async {
    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    print(json.decode(response.body));
  }

  Future<void> login(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDhZxHvF8t0hwZnXiHPux5jdWDWbfMJftA';
    return _authenticate(email, password, url);
  }

  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDhZxHvF8t0hwZnXiHPux5jdWDWbfMJftA';
    return _authenticate(email, password, url);
  }
}
