import 'package:chat_app_client/models/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UsersListState {}

class InitialUserslistState extends UsersListState {}

class LoadingUsers extends UsersListState {}

class UsersLoaded extends UsersListState {
  final List<User> users;
  UsersLoaded({this.users});
}

class LoadUsersFailed extends UsersListState {
  final String message;

  LoadUsersFailed({this.message});
}
