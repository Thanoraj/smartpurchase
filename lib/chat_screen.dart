import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dialogflow_grpc/v2beta1.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';
import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'chat_room_id_generator.dart';
import 'configuration.dart';
import 'constants.dart';
import 'message_stream.dart';
import 'typing_tile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key, this.chatId, this.receiver, this.sender})
      : super(key: key);

  final chatId;
  final receiver;
  final sender;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List collections = [];
  Future _getData;
  TextEditingController _controller = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  String typedMessage = '';
  String messageType = '';
  String user1 = '';
  String email = '';
  DialogflowGrpcV2Beta1 dialogflow;
  User loggedInUser = FirebaseAuth.instance.currentUser;
  RecorderStream _recorder = RecorderStream();
  StreamSubscription _recorderStatus;
  StreamSubscription<List<int>> _audioStreamSubscription;
  BehaviorSubject<List<int>> _audioStream;
  bool _isRecording = false;

  @override
  initState() {
    super.initState();
    createAccount();
    initPlugin();
  }

  @override
  void dispose() {
    _recorderStatus?.cancel();
    _audioStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> initPlugin() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    await Future.wait([_recorder.initialize()]);
  }

  Future<void> createAccount() async {
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/service.json'))}');
    dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);
  }

  void stopStream() async {
    print('stop');
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
  }

  void handleStream() async {
    print('start');
    _recorder.start();

    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((data) {
      print(data);
      _audioStream.add(data);
    });

    var biasList = SpeechContextV2Beta1(phrases: [
      'Dialogflow CX',
      'Dialogflow Essentials',
      'Action Builder',
      'HIPAA'
    ], boost: 20.0);

    // Create an audio InputConfig

    var config = InputConfigV2beta1(
        encoding: 'AUDIO_ENCODING_LINEAR_16',
        languageCode: 'en-US',
        sampleRateHertz: 16000,
        singleUtterance: false,
        speechContexts: [biasList]);

    final responseStream =
        dialogflow.streamingDetectIntent(config, _audioStream);

    responseStream.listen((data) {
      print('----');
      print(data);
      String transcript = data.recognitionResult.transcript;
      String queryText = data.queryResult.queryText;
      String fulfillmentText = data.queryResult.fulfillmentText;

      if (fulfillmentText.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(widget.chatId)
            .collection('chat')
            .add({
          'receiver': widget.receiver,
          'sender': widget.sender,
          'text': queryText,
          'date': DateTime.now().toIso8601String().toString(),
        });
        /*ChatMessage message = new ChatMessage(
            text: queryText,
            name: "You",
            type: true,
          );*/

        FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(widget.chatId)
            .collection('chat')
            .add({
          'receiver': email,
          'sender': 'Our Agent',
          'text': fulfillmentText,
          'date': DateTime.now().toIso8601String().toString(),
        });
      }
    }, onError: (e) {
      print(e);
    }, onDone: () {
      print('done');
    });
  }

  getCollections() async {
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
  }

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

  bool isTyping = false;

  void handleSubmitted(text) async {
    setState(() {
      isTyping = true;
    });

    String fulfillmentText = '';
    print(text);

    try {
      DetectIntentResponse data = await dialogflow.detectIntent(text, 'en-US');
      fulfillmentText = data.queryResult.fulfillmentText;
      print(fulfillmentText);
    } catch (e) {
      print(e);
    }

    if (fulfillmentText.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatId)
          .collection('chat')
          .add({
        'receiver': email,
        'sender': 'Our Agent',
        'text': fulfillmentText,
        'date': DateTime.now().toIso8601String().toString(),
      });
    }
    setState(() {
      isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 5,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: customShadow,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (val) {},
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
                              if (_controller.text != '') {
                                FirebaseFirestore.instance
                                    .collection('chatRoom')
                                    .doc(widget.chatId)
                                    .collection('chat')
                                    .add({
                                  'receiver': widget.receiver,
                                  'sender': widget.sender,
                                  'text': _controller.text.trim(),
                                  'date': DateTime.now()
                                      .toIso8601String()
                                      .toString(),
                                });
                                if (widget.receiver == 'bot') {
                                  //print('hi');
                                  handleSubmitted(
                                      _controller.text.trim().toLowerCase());
                                  _controller.clear();
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: MessagesStream(
                        chatId: widget.chatId,
                        receiver: widget.receiver,
                        loggedInUser: loggedInUser,
                      ),
                    ),
                    isTyping
                        ? TypingTile()
                        : SizedBox(
                            height: 20,
                          ),
                    Container(
                      decoration: kMessageContainerDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              onChanged: (value) {
                                typedMessage = value;
                              },
                              decoration: kMessageTextFieldDecoration,
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                if (_messageController.text != '') {
                                  _messageController.clear();
                                  FirebaseFirestore.instance
                                      .collection('chatRoom')
                                      .doc(widget.chatId)
                                      .collection('chat')
                                      .add({
                                    'receiver': widget.receiver,
                                    'sender': widget.sender,
                                    'text': typedMessage,
                                    'date': DateTime.now()
                                        .toIso8601String()
                                        .toString(),
                                  });
                                  if (widget.receiver == 'bot') {
                                    //print('hi');
                                    handleSubmitted(typedMessage);
                                  }
                                }
                              },
                              child: Icon(Icons.send_sharp)),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: _isRecording
                                  ? Color(0x754CAF50)
                                  : Colors.transparent,
                              child: Icon(
                                /*                              _isRecording ? Icons.mic_off :*/ Icons
                                    .mic,
                                size: 30,
                                color:
                                    _isRecording ? Colors.green : Colors.black,
                              ),
                            ),
                            onLongPressStart: (val) {
                              print(val);
                              setState(() {
                                _isRecording = true;
                              });
                              handleStream();
                            },
                            onLongPressEnd: (val) {
                              print(val);
                              setState(() {
                                _isRecording = false;
                              });
                              stopStream();
                            },
                            //onPressed: _isRecording ? stopStream : handleStream,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
