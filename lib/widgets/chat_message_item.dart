import 'package:chat_app_client/blocs/conversation/conversation_bloc.dart';
import 'package:chat_app_client/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatMessageItem extends StatefulWidget {
  final Message message;
  final bool left;

  const ChatMessageItem({Key key, @required this.message, @required this.left})
      : super(key: key);
  @override
  _ChatMessageItemState createState() => _ChatMessageItemState();
}

class _ChatMessageItemState extends State<ChatMessageItem> {
  @override
  Widget build(BuildContext context) {
    bool isNotMe = BlocProvider.of<ConversationBloc>(context).user.id !=
        widget.message.senderId;

    return Container(
      margin: EdgeInsets.only(
        left: isNotMe ? 50 : 0,
        right: isNotMe ? 0 : 50,
      ),
      child: Card(
        elevation: 0.1,
        color: isNotMe ? Colors.indigoAccent : Colors.black,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, bottom: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${widget.message.content}',
                      style: TextStyle(
                        fontSize: 17,
                        color: isNotMe?Colors.white:Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, bottom:5, top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${timeago.format(DateTime.parse(widget.message.createdAt))}',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontStyle:FontStyle.italic
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
