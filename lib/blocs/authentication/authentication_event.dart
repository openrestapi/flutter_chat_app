import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent {}

class CheckCurrentAuthState extends AuthenticationEvent {}
