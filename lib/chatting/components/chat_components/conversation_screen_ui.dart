import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  String recieveid, recievetoken, sendid, chatid, pic, name;

  Chat(this.recieveid, this.recievetoken, this.sendid, this.chatid, this.pic,
      this.name, {super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  TextEditingController msg = TextEditingController();
  String chatid = "";
  List l = [];
  List list = [];
  String token = "";
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    chatid = widget.chatid;
    get_token();
  }

  Future<void> get_token() async {
    var firestore = FirebaseFirestore.instance;
    final querySnapshot =
        await firestore.collection('users').doc(widget.recieveid);
    querySnapshot.get().then((DocumentSnapshot doc) {
      Map data = doc.data() as Map;
      token = data['devicetoken'];
      //list = data['chatid'];
      // for(int i=0;i<list.length;i++) {
      //   l.add(DateTime.now());
      //   if (list[i].contains(widget.recieveid) && list[i].contains(widget.sendid)) {
      //     chatid = list[i];
      //     break;
      //   }
      // }
      // print("0000000000000000000000000000");
      // print(chatid);
      // print("object1111111111111111");
      // _dataStream();
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Stream<DatabaseEvent> _dataStream() {
    final databaseReference =
        FirebaseDatabase.instance.ref().child(chatid);
    return databaseReference.onValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                  radius: 20, backgroundImage: NetworkImage(widget.name)),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.pic),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _dataStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dynamic data = snapshot.data?.snapshot.value;
                  List<dynamic> messages = [];

                  if (kDebugMode) {
                    print(data);
                  }
                  if (data != null) {
                    messages = (data as Map<dynamic, dynamic>)
                        .values
                        .map((value) => value as Map<dynamic, dynamic>)
                        .toList();

                    messages.sort((a, b) {
                      var adate = DateTime.parse(a['time']);
                      var bdate = DateTime.parse(b['time']);
                      return adate.compareTo(bdate);
                    });
                  }

                  return (messages.isEmpty)
                      ? const Center(
                          child: Text("No Chat Found"),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Align(
                              alignment:
                                  (messages[index]['sender'] == widget.sendid)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    (messages[index]['sender'] == widget.sendid)
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  (messages[index]['sender'] == widget.sendid)
                                      ? Container()
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(widget.name),
                                        ),
                                  Column(
                                    crossAxisAlignment: (messages[index]
                                                ['sender'] ==
                                            widget.sendid)
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(8.0),
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: (messages[index]['sender'] ==
                                                  widget.sendid)
                                              ? Colors.purple[200]
                                              : Colors.grey.shade300,
                                          borderRadius: (messages[index]
                                                      ['sender'] ==
                                                  widget.sendid)
                                              ? const BorderRadius.only(
                                                  topRight: Radius.circular(30),
                                                  topLeft: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15))
                                              : const BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  topLeft: Radius.circular(30),
                                                  bottomRight:
                                                      Radius.circular(15)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: (messages[index]
                                                      ['sender'] ==
                                                  widget.sendid)
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              messages[index]['msg'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: (messages[index]
                                                              ['sender'] ==
                                                          widget.sendid)
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  fontFamily: 'Poppins'),
                                              maxLines: null,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${DateTime.parse(messages[index]['time']).hour.toString()}:${DateTime.parse(messages[index]['time']).minute.toString()}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lottie/notfound.json',
                            height: MediaQuery.of(context).size.height * 0.2),
                        const Text(
                          'Loading.....',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Times New Roman'),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 8, right: 8, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: msg,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Times New Roman'),
                        decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Times New Roman',
                                fontSize: 16)),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded,
                            color: Colors.deepPurpleAccent),
                        onPressed: () async {
                          void addData(
                              String sender, String reciever, String msg) {
                            final DatabaseReference reference =
                                database.ref().child(chatid);
                            final Map<String, dynamic> data = {
                              'sender': sender,
                              'receiver': reciever,
                              'msg': msg,
                              'time': DateTime.now().toString(),
                            };
                            reference.push().set(data);
                          }
                          // var _firestore = FirebaseFirestore.instance;
                          // final querySnapshot = await _firestore.collection('users').doc(widget.recieveid);
                          addData(widget.sendid, widget.recieveid, msg.text);
                          Future<void> sendNotification(
                              String serverKey,
                              String deviceToken,
                              String title,
                              String body) async {
                            final url = Uri.parse(
                                'https://fcm.googleapis.com/fcm/send');
                            final headers = {
                              'Content-Type': 'application/json',
                              'Authorization': 'key=$serverKey',
                            };
                            final payload = {
                              'notification': {
                                'title': title,
                                'body': body,
                              },
                              'to': deviceToken,
                            };
                            final response = await http.post(
                              url,
                              headers: headers,
                              body: jsonEncode(payload),
                            );
                            if (response.statusCode == 200) {
                              if (kDebugMode) {
                                print('Notification sent successfully');
                              }
                            } else {
                              if (kDebugMode) {
                                print(
                                    'Failed to send notification. Error: ${response.body}');
                              }
                            }
                          }
                          if (kDebugMode) {
                            print("object");
                          }
                          if (kDebugMode) {
                            print(token);
                          }
                          sendNotification(
                              "AAAAr8hZjDo:APA91bFroryHY-qgm9ZMRJluD2amgqwK4kSXviJmuhUi_UMGZUwrqg_JoGJveskl3Pk72GpVsSVM9n0bAecKBcXrgmsXt81SDVzi5RCXIfGU-n971suMoyaHMzxXEDgIBrV6HK6H6zhD",
                              token,
                              widget.sendid,
                              msg.text);
                          msg.text = "";
                          _scrollToBottom();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//===================================================================================================================================================================================================================

class FakeChat extends StatefulWidget {
  final String name;
  final String email;
  final String profilePic;

  const FakeChat({
    Key? key,
    required this.name,
    required this.email,
    required this.profilePic,
  }) : super(key: key);

  @override
  State<FakeChat> createState() => _FakeChatState();
}

class _FakeChatState extends State<FakeChat>
    with SingleTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.profilePic)),
            const SizedBox(width: 5),
            Text(widget.name),
          ],
        ),
        backgroundColor: Colors.deepPurple.shade100,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Row(
                children: [
                  Material(
                    shadowColor: Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                    elevation: 5.0,
                    color: Colors.deepPurple[300],
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      child: Text(
                        'Hey, What\'s up buddy!! ',
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Input field and send button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          contentPadding: const EdgeInsets.only(
                            left: 14.0,
                            bottom: 8.0,
                            top: 8.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purple),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purple),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Send button
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(40),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              WaveWidget(
                                backgroundColor: Colors.white,
                                waveFrequency: 3,
                                config: CustomConfig(
                                  gradients: [
                                    [
                                      Colors.purple.withOpacity(0.8),
                                      Colors.purple.withOpacity(0.7)
                                    ],
                                    [
                                      Colors.purple.withOpacity(0.7),
                                      Colors.purple.withOpacity(0.9),
                                    ],
                                  ],
                                  durations: [5400, 9800],
                                  heightPercentages: [0.18, 0.24],
                                  blur: const MaskFilter.blur(
                                      BlurStyle.solid, 20),
                                ),
                                waveAmplitude: 2,
                                size: Size(
                                  MediaQuery.of(context).size.width.w,
                                  MediaQuery.of(context).size.height.h,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.87,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 5,
                                          width: 40,
                                          decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                      Lottie.asset('assets/lottie/card.json',
                                          height: 150),
                                      Text(
                                        " You're not Subscriber ,\n To Unlock Chat and many more features Unlock Premium ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            foreground: Paint()
                                              ..shader = ui.Gradient.linear(
                                                const Offset(0, 20),
                                                const Offset(150, 20),
                                                <Color>[
                                                  Colors.red,
                                                  Colors.yellow,
                                                ],
                                              ),
                                            // fontWeight: FontWeight.bold,
                                            fontFamily: 'Times New Roman',
                                            fontSize: 26),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        " Explore with great features ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w200,
                                            color: Colors.white,
                                            fontFamily: 'Times New Roman',
                                            fontSize: 18),
                                      ),
                                      const SizedBox(height: 20),
                                      Lottie.asset('assets/lottie/premium.json',
                                          height: 50),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.send_sharp),
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
