import 'package:chat_app_client/blocs/conversation/conversation_state.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConversationEvent {}

class LoadMessages extends ConversationEvent {}

class LoadMoreMessage extends ConversationEvent {
  final int limit;
  final int page;
  LoadMoreMessage({this.limit = 15, this.page = 1});
}

class YieldConversationState extends ConversationEvent {
  final ConversationState state;
  YieldConversationState({@required this.state});
}
