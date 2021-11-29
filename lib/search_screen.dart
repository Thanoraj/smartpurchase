import 'package:SmartPurchase/widgets/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/location_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Map collections = {};
  Future _getData;
  TextEditingController _controller = TextEditingController();

  @override
  initState() {
    super.initState();
    _getData = getCollections();
  }

  getCollections() async {
    collections = {};
    // ToDo : Create a collection called "ItemsCollection" and add search query text as "query" and results for the query as a array called "results" for each query in separate documents in firestore. Each result in "results" array is a map with name(name of product), left(co-ordinates from left side), top(co-ordinates from top), url(url for product image) keys.
    await FirebaseFirestore.instance
        .collection('ItemsCollection')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        collections[element['query']] = element['results'];
      });
    }).catchError((e) {
      print(e);
    });
    return collections;
  }

  List resultCollection = [];

  search(text) async {
    resultCollection = collections[text];
    resultCollection == null
        ? resultCollection = [
            {'name': 'No results found'}
          ]
        : null;
    setState(() {});
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: FutureBuilder(
              future: _getData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text(
                        'Search',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (val) {
                                    search(
                                        _controller.text.trim().toLowerCase());
                                  },
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: 'Search Products',
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.search),
                                onPressed: () {
                                  search(_controller.text.trim().toLowerCase());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (resultCollection.length > 0)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Column(children: [
                              Expanded(
                                child: Material(
                                  elevation: 5,
                                  child: Container(
                                    //height: 220,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          thickness: 1,
                                          indent: 5,
                                          endIndent: 5,
                                        );
                                      },
                                      itemCount: resultCollection.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 5),
                                          child: Row(children: [
                                            Visibility(
                                              visible: resultCollection[index]
                                                      ['name'] !=
                                                  'No results found',
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                height: 40,
                                                width: 40,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                      resultCollection[index]
                                                              ['url'] ??
                                                          'error',
                                                      errorBuilder: (context,
                                                          object, stacktrace) {
                                                    return SizedBox();
                                                  }),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              resultCollection[index]['name'],
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            Spacer(),
                                            MyButton(
                                              visible: resultCollection[index]
                                                      ['name'] !=
                                                  'No results found',
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                LocationScreen(
                                                                  name: resultCollection[
                                                                          index]
                                                                      ['name'],
                                                                  itemCoordinates: {
                                                                    "left": resultCollection[
                                                                            index]
                                                                        [
                                                                        'left'],
                                                                    "top": resultCollection[
                                                                            index]
                                                                        ['top']
                                                                  },
                                                                  url: resultCollection[
                                                                          index]
                                                                      ['url'],
                                                                )));
                                              },
                                              child: Text(
                                                resultCollection[index]
                                                            ['left'] ==
                                                        ''
                                                    ? 'Not Available'
                                                    : 'Find Location',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              disabled: resultCollection[index]
                                                      ['left'] ==
                                                  '',
                                              activeColor: Colors.white,
                                              disabledColor: Colors.grey[300],
                                            ),
                                          ]),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              //Spacer(),
                            ]),
                          ),
                        ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ]),
    );
  }
}
