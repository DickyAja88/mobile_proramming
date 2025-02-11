import 'dart:convert';
import '../helpers/api_url.dart';
import '../helpers/api.dart';
import '../model/login.dart';
class LoginBloc {
  static Future<Login> login({String? email, String? password}) async {
    String apiUrl = ApiUrl.login;
    var body = {"email": email, "password": password};
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    print(response);
    return Login.fromJson(jsonObj); // something in here
  }
}