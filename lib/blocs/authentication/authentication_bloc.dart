import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_app_client/api/API.dart';
import 'package:chat_app_client/api/AuthService.dart';
import 'package:chat_app_client/models/message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService;
  BehaviorSubject tokenRefreshed = new BehaviorSubject<bool>()..add(false);

  AuthenticationBloc(this.authService);
  @override
  AuthenticationState get initialState => AuthenticationUnInitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is CheckCurrentAuthState) {
      yield AuthenticationInProgress();
      FlutterSecureStorage storage = FlutterSecureStorage();
      var userData = await storage.read(key: 'userData');
      if (userData == null) {
        yield AuthenticationUnAuthenticated();
      } else {
        yield AuthenticationAuthenticated();
      }
    } else if (event is AttemptLogin) {
      yield AuthenticationInProgress();

      try {
        var userData =
            await this.authService.signin(event.username, event.password);
        await API.persistUserData(userData.data);

        yield AuthenticationSuccess();
      } catch (e) {
        if (e is DioError) {
          print(e.response);
          if (e.response.data['message'] != null) {
            yield AuthenticationFailed(
                message: e.response.data['message'].toString());
          } else {
            yield AuthenticationFailed(message: e.error);
          }
        }
      }
    }
  }
}
