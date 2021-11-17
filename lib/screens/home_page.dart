import 'package:SmartPurchase/cart_screen.dart';
import 'package:SmartPurchase/chat_screen.dart';
import 'package:SmartPurchase/screens/location_screen.dart';
import 'package:SmartPurchase/search_screen.dart';
import 'package:SmartPurchase/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewHomeScreen extends StatelessWidget {
  NewHomeScreen({Key key}) : super(key: key);
  final User loggedInUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'Smart Purchase',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'Home',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                MyButton(
                  child: Text(
                    '  Cart  ',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                MyButton(
                  child: Text(
                    'Search',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                MyButton(
                  child: Text(
                    '  Chat  ',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          sender: loggedInUser != null
                              ? loggedInUser.email
                              : 'test',
                          receiver: 'bot',
                          chatId:
                              'OurAgent_${loggedInUser != null ? loggedInUser.email : 'test'}',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
