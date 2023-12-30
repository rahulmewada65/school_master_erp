import 'dart:convert';
import 'package:http/http.dart';
import '../helpers/constants.dart';

class AuthService {
  var loginUri = Uri.parse('${Constants.BASE_URL}/auth/signin');
  var registerUri = Uri.parse('${Constants.BASE_URL}/auth/signup');
  Map<String, String> headers = {'Content-Type': 'application/json'};

  Future<Response?> login(String username, String password) async {
    var res = await post(loginUri,
        body: jsonEncode({"username": username, "password": password}),
        headers: headers);
    return res;
  }

  Future<Response?> register(
      String username, String password, String fullname, String phone) async {
    var res = await post(registerUri, body: {
      "email": username,
      "password": password,
      "fullname": fullname,
      "phone": phone
    });
    return res;
  }
}
