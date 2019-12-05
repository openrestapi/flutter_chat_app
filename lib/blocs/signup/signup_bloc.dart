import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app_client/api/AuthService.dart';
import 'package:dio/dio.dart';
import './bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthService authService;

  SignupBloc(this.authService);

  @override
  SignupState get initialState => SignupUninitializedState();

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is AttemptSignupEvent) {
      yield SignupInProgress();
      try {
        Response data = await this.authService.signup(
              event.username,
              event.email,
              event.country,
              event.password,
            );
        print(data);
        yield SignupSuccessful();
      } catch (e) {
        if (e is DioError) {
          print(e.response);
        } else {
          print(e.statusText);
        }
        yield SignupFailed(this.formatMessage(e));
      }
    }
  }

  String formatMessage(DioError e) {
    if (e.response.statusCode == 400) {
      return 'Make Sure you have filled all field';
    } else {
      return e.message;
    }
  }
}
