import 'package:SmartPurchase/cart_screen.dart';
import 'package:SmartPurchase/chat_screen.dart';
import 'package:SmartPurchase/search_screen.dart';
import 'package:SmartPurchase/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewHomeScreen extends StatelessWidget {
  NewHomeScreen({Key key}) : super(key: key);
  final User loggedInUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          color: Color(0xfff5f5f5),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.blueAccent,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Smart Purchase',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // Divider(
                //   thickness: 2,
                //   color: Colors.black,
                // ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Home',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                GridView.count(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  shrinkWrap: true,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  crossAxisCount: 2,
                  children: [
                    MyButton(
                      activeColor: Colors.white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/cart.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              'My Cart',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ]),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen()));
                      },
                    ),
                    MyButton(
                      activeColor: Colors.white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/search.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              'Search',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ]),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()));
                      },
                    ),
                    MyButton(
                      activeColor: Colors.white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/customer-support.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              'Chat',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ]),
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
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
