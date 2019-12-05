import 'package:meta/meta.dart';

@immutable
abstract class SignupState {}

class SignupUninitializedState extends SignupState {}

class SignupInProgress extends SignupState {}

class SignupFailed extends SignupState {
  final String message;

  SignupFailed(this.message);
}

class SignupSuccessful extends SignupState {}
