import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  @override
  ConversationState get initialState => InitialConversationState();

  @override
  Stream<ConversationState> mapEventToState(
    ConversationEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
