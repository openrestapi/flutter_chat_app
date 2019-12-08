import 'dart:async';
import 'package:chat_app_client/api/chatService.dart';
import 'package:chat_app_client/blocs/socketIo/socketio_bloc.dart';
import 'package:chat_app_client/blocs/socketIo/socketio_state.dart';
import 'package:chat_app_client/models/message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_app_client/models/user.dart';
import './bloc.dart';
import 'package:rxdart/rxdart.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final User user;
  final SocketioBloc socketioBloc;
  final ChatService chatService;
  List<Message> messages;
  BehaviorSubject online = new BehaviorSubject<bool>();
  BehaviorSubject sending = new BehaviorSubject<bool>()..add(false);
  BehaviorSubject error = new BehaviorSubject<bool>()..add(false);
  BehaviorSubject unreadMessage = new BehaviorSubject<Message>()..add(null);
  BehaviorSubject lastMessage = new BehaviorSubject<Message>()..add(null);
    StreamController  lastestMessage ;

  ConversationBloc({
    Key key,
    @required this.socketioBloc,
    @required this.user,
    @required this.chatService,
  }) {
    lastestMessage = new StreamController();
    this.messages = [];
    this.socketioBloc.listen((SocketioState state) {
      if (state is WSOnlineUsersId) {
        this.online.add(state.usersId.contains(this.user.id));
      }
      if (state is NewMessage) {
        print('--------SOCKET new Message----------');
        this.messages.add(state.message);
        this.add(
          YieldConversationState(
            state: MessagesLoaded(this.messages),
          ),
        );
        unreadMessage.add(state.message);
        lastestMessage.sink.add(state.message);


      }
    });
  }

  sendMessage(String message) async {
    sending.add(true);
    error.add(false);
    try {
      Response resp = await this.chatService.sendMessage(this.user.id, message);
      Message m = Message.fromJson(resp.data);
      messages.add(m);
      this.add(
        YieldConversationState(
          state: MessagesLoaded(messages),
        ),
      );
      sending.add(false);
    } catch (e) {
      print(e);
      print('error sening message');
      sending.add(false);
      error.add(true);
    }
  }

  @override
  ConversationState get initialState => InitialConversationState();

  @override
  Stream<ConversationState> mapEventToState(
    ConversationEvent event,
  ) async* {
    if (event is LoadMessages) {
      yield LoadingMessages();
      try {
        this.messages = await this.chatService.getMessages(this.user.id);
        yield MessagesLoaded(this.messages);
      } catch (e) {
        print(e);
        yield LoadMessagesError();
      }
    }

    if (event is YieldConversationState) {
      yield event.state;
    }
  }
}
