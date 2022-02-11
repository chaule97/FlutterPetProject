import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthenticationService {
  final Dio _dio = Dio();

  dynamic login(String username, String password) async {
    var link = dotenv.env['API_ROOT']! + '/token/';

    try {
      var response = await _dio.post(link, data: { 'username': username, 'password': password });
      return response.data;
    } catch (e) {
      return false;
    }
  }

  dynamic refreshToken(String token) async {
    var link = dotenv.env['API_ROOT']! + '/access-tokens/';
    try {
      var response = await _dio.post(link, data: { 'refreshToken': token });
      return response.data;
    } catch (e) {
      return false;
    }
  }
}