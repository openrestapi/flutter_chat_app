import 'package:chat_app_client/api/chatService.dart';
import 'package:chat_app_client/blocs/bloc.dart';
import 'package:chat_app_client/models/user.dart';
import 'package:chat_app_client/pages/conversation_page.dart';
import 'package:chat_app_client/widgets/user_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersListPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  List<User> users;
  @override
  void initState() {
    users = [];
    BlocProvider.of<UsersListBloc>(context)..add(LoadUsers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                BlocProvider.of<UsersListBloc>(context).add(LoadUsers());
              },
              child: Icon(Icons.refresh),
            )
          ],
        ),
        body: BlocListener<UsersListBloc, UsersListState>(
            listener: (context, state) {},
            child: BlocBuilder<UsersListBloc, UsersListState>(
              builder: (context, state) {
                if (state is LoadingUsers) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadUsersFailed) {
                  return Center(
                    child: Text('${state.message}'),
                  );
                } else if (state is UsersLoaded) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      var _conversationBloc =  ConversationBloc(
                        user: state.users[index],
                        socketioBloc: BlocProvider.of<SocketioBloc>(context),
                        chatService: new ChatService(),
                      );
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return BlocProvider.value(
                              value: _conversationBloc
                                ..add(
                                  LoadMessages(),
                                ),
                              child: ConversationPage(),
                            );
                          }));
                        },
                        child: UserListItem(
                            user: state.users[index],
                            conversationBloc: _conversationBloc),
                      );
                    },
                  );
                }
                return Container();
              },
            )));
  }
}
