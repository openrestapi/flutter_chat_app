import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app_client/api/chatService.dart';
import 'package:chat_app_client/models/user.dart';
import 'package:dio/dio.dart';
import './bloc.dart';

class UsersListBloc extends Bloc<UsersListEvent, UsersListState> {
  final ChatService chatService;

  UsersListBloc(this.chatService);
  @override
  UsersListState get initialState => InitialUserslistState();

  @override
  Stream<UsersListState> mapEventToState(
    UsersListEvent event,
  ) async* {
    if (event is LoadUsers) {
      yield LoadingUsers();
      try {
        List<User> users = await chatService.getUsers();
        yield UsersLoaded(users: users);
      } catch (e) {
        print(e);
        if (e is DioError) {
          yield LoadUsersFailed(message: e.message);
        } else {
          yield LoadUsersFailed(message: e.message);
        }
      }
    }
  }
}
