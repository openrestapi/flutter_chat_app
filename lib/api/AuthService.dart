import 'package:dio/dio.dart';

Dio dio = new Dio();
final String serverUrl = 'https://chat-app-237.herokuapp.com';

class AuthService {
  Future<Response<dynamic>> signin(String username, String password) {
    return dio.post(serverUrl + '/api/auth/signin');
  }

  Future<Response<dynamic>> signup(
    String username,
    String email,
    String country,
    String password,
  ) {
    return dio.post(serverUrl + '/api/auth/signup', data: {
      'username': username,
      'email': email,
      'country': country,
      'password': password,
    });
  }
}
