import 'package:meta/meta.dart';

@immutable
abstract class UsersListEvent {}

class LoadUsers extends UsersListEvent {}
