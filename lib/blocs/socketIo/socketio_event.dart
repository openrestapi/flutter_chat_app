import 'package:meta/meta.dart';

import 'socketio_state.dart';

@immutable
abstract class SocketioEvent {}

class YieldState extends SocketioEvent {
  final SocketioState state;

  YieldState(this.state);
}
