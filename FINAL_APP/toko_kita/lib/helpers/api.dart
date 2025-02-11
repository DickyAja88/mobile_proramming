import 'dart:io';
import 'package:http/http.dart' as http;
import 'user_info.dart';
import 'app_exception.dart';

class Api {
  Future<dynamic> post(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final response = await http.post(Uri.parse(url),
          body: data,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> put(String url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final response = await http.put(
        Uri.parse(url),
        body: data,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get(dynamic url) async {
    var token = await UserInfo().getToken();
    print(token);
    var responseJson;
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
      print("response get : $response");
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print("catch :$e");
    }
    return responseJson;
  }

  Future<dynamic> delete(dynamic url) async {
  var token = await UserInfo().getToken();
  var responseJson;
  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    responseJson = _returnResponse(response);
  } on SocketException {
    throw FetchDataException('No Internet connection');
  }
    return responseJson;
  }

  Future<dynamic> postMultipart(String url, Map<String, String> fields, File? file) async {
  var token = await UserInfo().getToken();
  var responseJson;
  try {
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('gambar', file.path));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    
    print('Response Body: $responseBody');
    print('Response Status Code: ${response.statusCode}');
    
    responseJson = _returnResponse(http.Response(responseBody, response.statusCode));
  } on SocketException {
    throw FetchDataException('No Internet connection');
  }
  return responseJson;
}




  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with Status Code: ${response.statusCode}');
    }
  }
}
