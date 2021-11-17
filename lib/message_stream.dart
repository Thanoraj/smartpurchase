import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_bubble.dart';
//import 'package:firebase_auth/firebase_auth.dart';

final _fireStore = FirebaseFirestore.instance;
//User loggedInUser;

class MessagesStream extends StatelessWidget {
  MessagesStream(
      {@required this.receiver,
      @required this.loggedInUser,
      @required this.chatId});
  final receiver;
  final loggedInUser;
  final chatId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('chatRoom')
          .doc(chatId)
          .collection('chat')
          .orderBy('date')
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        List<Widget> messageBubbles = [];
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          );
        } else {
          final messages = snapshot.data.docs.reversed;

          for (var message in messages) {
            final messageText = message['text'];
            final messageSender = message['sender'];
            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: (loggedInUser != null ? loggedInUser.email : 'test') ==
                  messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              shrinkWrap: true,
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }
}
