import 'package:chat_app_client/models/message.dart';
import 'package:chat_app_client/models/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SocketioState {}

class InitialSocketioState extends SocketioState {}

class WSOnlineUsersId extends SocketioState {
  final List<dynamic> usersId;
  WSOnlineUsersId(this.usersId);
}

class WSNewRegistratedUser extends SocketioState {
  final User user;
  WSNewRegistratedUser(this.user);
}

class NewMessage extends SocketioState {
  final Message message;
  NewMessage(this.message);
}
