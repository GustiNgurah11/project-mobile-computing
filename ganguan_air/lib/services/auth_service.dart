import 'dart:convert';

import 'package:http/http.dart'
    as http;

import '../config/api.dart';

class AuthService {

  /// LOGIN
  static Future login(
    String email,
    String password,
  ) async {

    var url = Uri.parse(
      Api.baseUrl +
      "auth/login.php",
    );

    var response = await http.post(

      url,

      body: {
        "email": email,
        "password": password,
      },
    );

    return jsonDecode(
      response.body,
    );
  }

  /// REGISTER
  static Future register(
    String nama,
    String email,
    String password,
  ) async {

    var url = Uri.parse(
      Api.baseUrl +
      "auth/register.php",
    );

    var response = await http.post(

      url,

      body: {
        "nama": nama,
        "email": email,
        "password": password,
      },
    );

    return jsonDecode(
      response.body,
    );
  }
}