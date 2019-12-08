import 'package:chat_app_client/models/message.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConversationState {}

class InitialConversationState extends ConversationState {}

class LoadingMessages extends ConversationState {}

class LoadMessagesError extends ConversationState {}

class MessagesLoaded extends ConversationState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
}
