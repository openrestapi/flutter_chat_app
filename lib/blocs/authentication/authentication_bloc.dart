import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
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
    }
  }
}
