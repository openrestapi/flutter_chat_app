import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationUnInitialized extends AuthenticationState {}

class AuthenticationUnAuthenticated extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationFailed extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {}

class AuthenticationInProgress extends AuthenticationState {}
