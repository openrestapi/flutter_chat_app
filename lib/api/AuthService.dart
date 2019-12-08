import 'package:chat_app_client/api/API.dart';
import 'package:dio/dio.dart';

Dio dio = new Dio();
class AuthService {
  Future<Response<dynamic>> signin(String username, String password) {
    return dio.post(
      API.serverUrl + '/v1/api/auth/signin',
      data: {
        'username': username,
        'password': password,
      },
    );
  }

  Future<Response<dynamic>> signup(
    String username,
    String email,
    String country,
    String password,
  ) {
    return dio.post(
      API.serverUrl + '/v1/api/auth/signup',
      data: {
        'username': username,
        'email': email,
        'country': country,
        'password': password,
      },
    );
  }
}
