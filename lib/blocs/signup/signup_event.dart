import 'package:meta/meta.dart';

@immutable
abstract class SignupEvent {}

class AttemptSignupEvent extends SignupEvent {
  final String username;
  final String email;
  final String country;
  final String password;

  AttemptSignupEvent({
    @required this.username,
    @required this.email,
    @required this.country,
    @required this.password,
  });
}
