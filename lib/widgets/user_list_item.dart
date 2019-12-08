import 'package:chat_app_client/blocs/bloc.dart';
import 'package:chat_app_client/models/message.dart';
import 'package:chat_app_client/models/user.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserListItem extends StatefulWidget {
  final User user;
  final ConversationBloc conversationBloc;

  const UserListItem({
    Key key,
    @required this.user,
    @required this.conversationBloc,
  }) : super(key: key);
  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.1,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 5, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, bottom: 10, top: 5),
                  child: Text(
                    '${widget.user.username}',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: StreamBuilder(
                    stream: widget.conversationBloc.online,
                    builder: (BuildContext ctx, value) {
                      return _buildStatus(value.data);
                    },
                  ),
                )
              ],
            ),
          ),


          StreamBuilder(
              stream: widget.conversationBloc.lastestMessage.stream,
              builder: (context, snapshot) {
                if(snapshot.data !=null && (snapshot.data.senderId==widget.user.id || snapshot.data.receiverId==widget.user.id)){
                  return  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 20, top: 5),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, bottom: 5, top: 5),
                            child: Text(
                              '${snapshot.data?.content}',
                              overflow:TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text('${timeago.format( DateTime.parse(snapshot.data?.createdAt))}',
                            style: TextStyle(fontStyle: FontStyle.italic,fontSize: 12),),
                        )
                      ],
                    ),);
                } else {
                  return Container();
                }
              }),



        ],),);

  }

  Widget _buildStatus(bool value) {
    return new Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50),),
        color: value == true ? Colors.green : Colors.red,
      ),

    );
  }
}
