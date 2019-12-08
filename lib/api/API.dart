import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class API {
  //static final String serverUrl = 'http://192.168.43.141:4000';
  static final String serverUrl = 'https://chat-app-237.herokuapp.com';

  static final StreamController ctrl = StreamController();



  static getToken() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    var userData = await storage.read(key: 'userData');
    if (userData != null) {
      Map<String, dynamic> json = jsonDecode(userData);
      return json['accessToken'];
    } else {
      return null;
    }
  }

  static getUserData() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    var userData = await storage.read(key: 'userData');
    if (userData != null) {
      return jsonDecode(userData);
    } else {
      return null;
    }
  }

  static persistUserData(data) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(
      key: 'userData',
      value: jsonEncode(data),
    );
  }

  static refreshToken() async {
    Dio dio = new Dio();
    var response = await dio.get(API.serverUrl + '/v1/api/auth/refresh',
        queryParameters: {'accessToken': await API.getToken()});
    API.persistUserData(response.data);
    API.ctrl.sink.add(true);
    API.ctrl.sink.add(false);
    print('-------------REFRESH TOKEN CALLED ---------');
  }

  static deleteUserData() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(
      key: 'userData',
    );
  }
}
