import 'dart:ui' show FontWeight, Radius;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'home_page.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email, _password, _userName;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.asset(
                        bgRegister,
                        height: height * 0.40,
                        width: width,
                        fit: BoxFit.fill,
                      ),
                      Container(
                        height: height * 0.40,
                        width: width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              stops: [0.3, 0.9],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.white]),
                        ),
                        //  color: Colors.lightBlueAccent.withOpacity(0.3),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Smart Purchase",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w700),
                              ),
                              //Text(slogan, style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 20),
                    child: Container(
                      child: Text(
                        "  Register",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withOpacity(0.2),
                              Colors.transparent
                            ],
                          ),
                          border: Border(
                              left: BorderSide(color: primaryColor, width: 5))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onSaved: (value) {
                        _email = value;
                      },
                      validator: (email) {
                        if (email.isEmpty)
                          return "please Enter Email";
                        else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email)) return "Invalid Emailaddress";
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          prefixIcon: Icon(Icons.email, color: primaryColor),
                          labelText: "EMAIL ADDRESS",
                          labelStyle:
                              TextStyle(color: primaryColor, fontSize: 16)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onSaved: (value) {
                        _userName = value;
                      },
                      validator: (userName) {
                        if (userName.isEmpty)
                          return "please Enter Email";
                        else if (userName.trim().length < 5)
                          return "Please input valid name";
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          prefixIcon: Icon(Icons.email, color: primaryColor),
                          labelText: "USER NAME",
                          labelStyle:
                              TextStyle(color: primaryColor, fontSize: 16)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: TextFormField(
                      onSaved: (value) {
                        _password = value;
                      },
                      validator: (password) {
                        if (password.isEmpty)
                          return "please Enter Password";
                        else if (password.length < 8 || password.length > 15)
                          return "Password length is incorrect";
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          prefixIcon:
                              Icon(Icons.lock_open, color: primaryColor),
                          labelText: "PASSWORD",
                          labelStyle:
                              TextStyle(color: primaryColor, fontSize: 16)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: SizedBox(
                          height: height * 0.08,
                          width: width - 30,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            color: primaryColor,
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _email, password: _password)
                                    .then((info) {
                                  FocusScope.of(context).unfocus();
                                  User loggedInUser =
                                      FirebaseAuth.instance.currentUser;
                                  loggedInUser.updateDisplayName(_userName);
                                  FirebaseFirestore.instance
                                      .collection("User")
                                      .doc(loggedInUser.uid)
                                      .set({
                                    'email': _email,
                                    'uid': loggedInUser.uid,
                                    'userName': _userName,
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewHomeScreen(),
                                    ),
                                  );
                                }).catchError((e) {
                                  print(e);
                                });
                              }
                            },
                            child: Text(
                              "Register Account",
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                  color: Colors.white),
                            ),
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Login Account",
                              style:
                                  TextStyle(color: primaryColor, fontSize: 16)))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
