import 'package:flutter/material.dart';

class TypingTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 5,
            //if (isMe == true) {
            color: Colors.grey,
            //}
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: Text(
                'typing ...',
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
