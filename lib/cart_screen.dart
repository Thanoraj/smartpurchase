import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List collections = [];

  Future _getData;

  TextEditingController _controller = TextEditingController();

  @override
  initState() {
    super.initState();
    _getData = getPrice();
    //_getData = getCollections();
  }

  /*getCollections() async {
    collections = [];
    await FirebaseFirestore.instance
        .collection('ItemsCollection')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        collections.add(element['CollectionList']);
      });
    });

    return collections;
  }*/

  List resultCollection = [];

  search(text) async {
    resultCollection = [];
    for (List collection in collections) {
      if (collection.contains(text)) {
        resultCollection = collection;
      }
    }
    setState(() {});
  }

  Map priceList = {};

  getPrice() async {
    priceList = {};

    await FirebaseFirestore.instance
        .collection("Price List")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        priceList[element['id']] = element['price'];
      });
    });
    print(priceList);
    setState(() {});
  }

  double total = 0.00;
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            Text(
              'My Cart',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FutureBuilder(
                      future: _getData,
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.done) {
                          return StreamBuilder(
                              stream: FirebaseDatabase.instance
                                  .reference()
                                  .child('Items')
                                  // .child('DHT11')
                                  .onValue,
                              builder: (context, snapShot) {
                                print(snapShot.hasData);
                                if (snapShot.hasData &&
                                    !snapShot.hasError &&
                                    snapShot.data != null) {
                                  print('hii');
                                  print(snapShot.data.snapshot.value);
                                  print(priceList);
                                  total = 0;
                                  for (int i = 1;
                                      i - 1 <
                                          snapShot.data.snapshot.value.length;
                                      i++) {
                                    print(priceList[snapShot
                                        .data.snapshot.value[i - 1]
                                        .toString()
                                        .replaceAll('_', ' ')]);
                                    total += double.parse(priceList[snapShot
                                                .data.snapshot.value[i - 1]
                                                .toString()
                                                .replaceAll('_', ' ')]
                                            .toString() ??
                                        '0.00');
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: ListView(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('No.'),
                                              Divider(
                                                thickness: 1,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  for (int i = 1;
                                                      i - 1 <
                                                          snapShot.data.snapshot
                                                              .value.length;
                                                      i++)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Text(i.toString()),
                                                    )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('Product'),
                                              Divider(
                                                thickness: 1,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  for (int i = 1;
                                                      i - 1 <
                                                          snapShot.data.snapshot
                                                              .value.length;
                                                      i++)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Text(snapShot.data
                                                          .snapshot.value[i - 1]
                                                          .toString()
                                                          .replaceAll(
                                                              '_', ' ')),
                                                    )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Qty'),
                                              Divider(
                                                thickness: 1,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  for (int i = 1;
                                                      i - 1 <
                                                          snapShot.data.snapshot
                                                              .value.length;
                                                      i++)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Text('1'),
                                                    )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Price'),
                                              Divider(
                                                thickness: 1,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  for (int i = 1;
                                                      i - 1 <
                                                          snapShot.data.snapshot
                                                              .value.length;
                                                      i++)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Text(priceList[
                                                              snapShot
                                                                  .data
                                                                  .snapshot
                                                                  .value[i - 1]
                                                                  .toString()
                                                                  .replaceAll(
                                                                      '_',
                                                                      " ")] ??
                                                          '0'),
                                                    )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          Spacer(),
                                          Text('Total'),
                                          Spacer(),
                                          Text(total.toStringAsFixed(2)),
                                        ],
                                      ),
                                    ]),
                                  );
                                } else {
                                  return Container();
                                }
                              });
                        } else {
                          return Container();
                        }
                      }),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ]),
        ),
      ]),
    );
  }
}
