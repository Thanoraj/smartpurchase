import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key key, this.itemCoordinates, this.url, this.name})
      : super(key: key);
  final Map itemCoordinates;
  final String url;
  final String name;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: ListView(
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
                    widget.name,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(overflow: Overflow.visible, children: [
                    Image.asset(
                      'assets/images/N.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                      top: 435 *
                          (MediaQuery.of(context).size.width - 40) *
                          double.parse(390.toString()) /
                          (320 * 435),
                      left: 320 *
                          double.parse(10.toString()) /
                          (MediaQuery.of(context).size.width - 40),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey,
                        elevation: 5,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text('Exit'),
                        ),
                      ),
                    ),
                    StreamBuilder(
                        stream: FirebaseDatabase.instance
                            .reference()
                            .child('Coordinates')
                            .onValue,
                        builder: (context, snapShot) {
                          if (snapShot.hasData &&
                              !snapShot.hasError &&
                              snapShot.data != null) {
                            return (Positioned(
                              top: 435 *
                                  (MediaQuery.of(context).size.width - 40) *
                                  double.parse(snapShot.data.snapshot.value[1]
                                      .toString()) /
                                  (320 * 435),
                              left: 320 *
                                  double.parse(snapShot.data.snapshot.value[0]
                                      .toString()) /
                                  (MediaQuery.of(context).size.width - 40),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Color(0x6FF44336),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 3,
                                ),
                              ),
                            ));
                          } else {
                            return Container();
                          }
                        }),
                    Positioned(
                      top: 435 *
                          (MediaQuery.of(context).size.width - 40) *
                          double.parse(
                              widget.itemCoordinates['top'].toString()) /
                          (320 * 435),
                      left: 320 *
                          double.parse(
                              widget.itemCoordinates['left'].toString()) /
                          (MediaQuery.of(context).size.width - 40),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Color(0x662196F3),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 13,
                          backgroundImage: NetworkImage(widget.url ??
                              'https://firebasestorage.googleapis.com/v0/b/smart-purchase-9df03.appspot.com/o/items%20image%2FBaby%20Powder.png?alt=media&token=01d7f1da-52a4-470c-bf11-0e410bf7be92'),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
