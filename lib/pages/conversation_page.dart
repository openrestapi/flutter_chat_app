import 'dart:async';

import 'package:chat_app_client/blocs/bloc.dart';
import 'package:chat_app_client/widgets/chat_message_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  ScrollController _scrollController;
  TextEditingController _textEditingController;
  ConversationBloc _conversationBloc;

  _scrollBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent + 50,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  _onScroll(){
    if(_scrollController.position.maxScrollExtent.toDouble()==_scrollController.offset.toDouble()){
      if(_conversationBloc.unreadMessage != null){
        _conversationBloc.unreadMessage.add(null);
      }
    }
    print('max:'+_scrollController.position.maxScrollExtent.toString()+" Current:"+_scrollController.offset.toString());
  }

  @override
  void initState() {
    ;
    _scrollController = new ScrollController();

    _textEditingController = new TextEditingController();
    _conversationBloc = BlocProvider.of<ConversationBloc>(context);
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(milliseconds: 2000), _scrollBottom);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(ConversationPage oldWidget) {
    print('upfated');
    Timer(Duration(milliseconds: 1000), _scrollBottom);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              BlocProvider.of<ConversationBloc>(context)
                  .user
                  .username
                  .toUpperCase(),
            ),
            StreamBuilder(
              stream: _conversationBloc.sending,
              builder: (ctx, state) {
                if (state.data == false) {
                  return Container();
                } else {
                  _scrollBottom();
                  return Text(
                    'sending..',
                    style: TextStyle(fontSize: 12),
                  );
                }
              },
            ),
            StreamBuilder(
              stream: _conversationBloc.error,
              builder: (ctx, state) {
                if (state.data == false) {
                  return Container();
                } else {
                  return Text(
                    'mot sent',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  );
                }
              },
            ),
            StreamBuilder(
              stream: _conversationBloc.unreadMessage,
              builder: (ctx, state) {
                if (state.data == null) {
                  return Container();
                } else {
                  return InkWell(
                    onTap: _scrollBottom,
                    child: Text(
                      'new Message',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  );
                }
              },
            )
          ],
        ),
        actions: <Widget>[],
      ),
      body: BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
          if (state is LoadingMessages) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadMessagesError) {
            return _refreshWidget();
          } else if (state is MessagesLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    padding: EdgeInsets.only(top: 0),
                    height: MediaQuery.of(context).size.height - 130,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        return ChatMessageItem(
                          message: state.messages[index],
                          left: false,
                        );
                      },
                    ),
                  ),
                  _buildMessageTextField(),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _refreshWidget() {
    return Card(
      elevation: 0.2,
      child: Container(
        width: 200,
        height: 200,
        child: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            BlocProvider.of<ConversationBloc>(context).add(LoadMessages());
          },
        ),
      ),
    );
  }

  Widget _buildMessageTextField() {
    return Container(
      child: Container(
        height: 50,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write your reply',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Color(0xffAEA4A3),
                  ),
                ),
                textInputAction: TextInputAction.send,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                onSubmitted: (_) {
                  addNewMessage();
                },
              ),
            ),
            Container(
              width: 50,
              child: InkWell(
                onTap: addNewMessage,
                child: Icon(
                  Icons.send,
                  color: Color(0xFFdd482a),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void addNewMessage() {
    BlocProvider.of<ConversationBloc>(context)
        .sendMessage(_textEditingController.text);
    _textEditingController.clear();
  }
}
