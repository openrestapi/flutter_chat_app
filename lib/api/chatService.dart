import 'dart:convert';

import 'package:chat_app_client/models/message.dart';
import 'package:chat_app_client/models/user.dart';
import 'package:dio/dio.dart' as dio2;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'API.dart';

class ChatService {
  Dio dio = new Dio();
  Future<Dio> getDio() async {
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (dio2.Options options) async {
          FlutterSecureStorage storage = FlutterSecureStorage();
          var userData = await storage.read(key: 'userData');
          if (userData == null) {
            print('no token , request token first');
            // dio.lock();
            return options;
          } else {
            try {
              Map<String, dynamic> json = jsonDecode(userData);
              options.headers['Authorization'] =
                  'Bearer ' + json['accessToken'];
            } catch (e) {
              print(e);
            }

            print('\n');
            print('-------------- request options ------');
            print(options.headers);
            print('\n');
            return options;
          }
        },
        onResponse: (dio2.Response response) async {
          return response;
        },
        onError: (dio2.DioError error) async {
          if (error.response?.statusCode == 401) {
            dio.interceptors.requestLock.lock();
            dio.interceptors.responseLock.lock();
            dio2.RequestOptions options = error.response.request;
            await API.refreshToken();
            var token = await API.getToken();
            options.headers['Authorization'] = "Bearer " + token;
            dio.interceptors.requestLock.unlock();
            dio.interceptors.responseLock.unlock();
            return dio.request(options.path, options: options);
          } else {
            return error;
          }
        },
      ),
    );
    return dio;
  }

  Future<List<User>> getUsers() async {
    Dio dio = await this.getDio();
    var responseData = await dio.get(API.serverUrl + '/v1/api/users');
    List<User> users = [];
    for (var d in responseData.data) {
      users.add(User.fromJson(d));
    }
    return users;
  }

  sendMessage(userId, message) async {
    Dio dio = await this.getDio();
    return dio.post(
      API.serverUrl + '/v1/api/chat/$userId/sendMessage',
      data: {
        'message': message,
      },
    );
  }

  Future<List<Message>> getMessages(userId) async {
    Dio dio = await this.getDio();
    List<Message> messages = [];
    print(API.serverUrl + '/v1/api/chat/$userId/messages');
    Response resp =
        await dio.get(API.serverUrl + '/v1/api/chat/$userId/messages');
    print(resp.data);
    for (var m in resp.data) {
      messages.add(Message.fromJson(m));
    }
    return messages;
  }
}
