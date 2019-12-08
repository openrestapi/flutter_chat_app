import 'dart:async';
import 'package:chat_app_client/api/API.dart';
import 'package:chat_app_client/blocs/bloc.dart';
import 'package:chat_app_client/models/message.dart';
import 'package:chat_app_client/models/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bloc/bloc.dart';
import './bloc.dart';

class SocketioBloc extends Bloc<SocketioEvent, SocketioState> {
  final AuthenticationBloc _authenticationBloc;
  SocketioBloc(this._authenticationBloc) {
    //
    // Initialize a single listener which simply prints the data
    // as soon as it receives it
    //



    this._authenticationBloc.listen((AuthenticationState state) {
      if (state is AuthenticationSuccess) {
        initSocket();
      } else if (state is AuthenticationAuthenticated) {
        initSocket();
      }
    });
    API.ctrl.stream.listen((data){
      if(data == true){
        initSocket();
      }
    });
  }

  initSocket() async {
    var userData = await API.getUserData();
    IO.Socket socket = IO.io(API.serverUrl + '/chat', <String, dynamic>{
      'query': 'token=' + userData['accessToken'],
      'transports': ['websocket'],
      //'extraHeaders': {'Authorization': 'Bearer ' + userData['accessToken']}
    });
    socket.on('connect', (_) {
      print('connected');
    });

    socket.on('disconnect', (_) {
      print('disconnected');
    });
    socket.on('newMessage/user/${userData["data"]["id"]}', (data) {
      this.add(YieldState(NewMessage(Message.fromJson(data))));
    });

    socket.on('users/new', (data) {
      this.add(YieldState(WSNewRegistratedUser(User.fromJson(data))));
    });
    socket.on('users/online', (data) {
      this.add(YieldState(WSOnlineUsersId(data)));
    });
  }

  @override
  SocketioState get initialState => InitialSocketioState();

  @override
  Stream<SocketioState> mapEventToState(
    SocketioEvent event,
  ) async* {
    if (event is YieldState) {
      yield event.state;
    }
  }
}
