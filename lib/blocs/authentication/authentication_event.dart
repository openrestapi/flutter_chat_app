import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent {}

class CheckCurrentAuthState extends AuthenticationEvent {}

class AttemptLogin extends AuthenticationEvent {
  final String username;
  final String password;

  AttemptLogin({@required this.username, @required this.password});
}
