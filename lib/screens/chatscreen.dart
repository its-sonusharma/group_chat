import 'package:chitti/components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'Chat_Screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async{
    try{
      final user = await _auth.currentUser();
      if(user != null)
        loggedUser = user;
    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(style: TextStyle(color: Colors.black54),
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _fireStore.collection('messages').add({
                        'text':messageText,
                        'sender':loggedUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder:(context, snapshot) {
        if(!snapshot.hasData) {
              return Center(
                child:CircularProgressIndicator(),
              );
          }
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble>messageBubbles = [];
          for(var message in messages){
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];

            final currentUser = loggedUser.email;

            if(currentUser == messageSender)
              {

              }

            final messageBubble = MessageBubble(sender: messageSender,text: messageText,itsMe: currentUser==messageSender,);
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: Padding(
              padding:  EdgeInsets.all(8.0),
              child: ListView(
                reverse: true,
                children: messageBubbles,
              ),
            ),
          );
      }
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text,this.sender,this.itsMe});
  final String text;
  final String sender;
  final bool itsMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: itsMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(fontSize: 10.0),),
          Material(
            elevation: 8.0,
            borderRadius: itsMe ? BorderRadius.only(bottomLeft: Radius.circular(20),topRight: Radius.circular(20),topLeft: Radius.circular(20)) :
            BorderRadius.only(bottomRight: Radius.circular(20),topRight: Radius.circular(20),topLeft: Radius.circular(20)),
            color: itsMe ? Colors.blueGrey:Colors.deepPurple,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 8.0),
              child: Text(text,style: TextStyle(fontSize: 15),),
            ),
          ),
        ],
      ),
    );
  }
}
