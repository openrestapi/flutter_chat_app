import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class UsersListBloc extends Bloc<UsersListEvent, UsersListState> {
  @override
  UsersListState get initialState => InitialUserslistState();

  @override
  Stream<UsersListState> mapEventToState(
    UsersListEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
