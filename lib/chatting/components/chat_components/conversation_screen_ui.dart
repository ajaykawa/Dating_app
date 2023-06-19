import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'package:firebase_database/firebase_database.dart';

class ConversationScreenUI extends StatefulWidget {
  final String name;
  final String email;
  final String profilePic;

  const ConversationScreenUI({
    required this.email,
    required this.profilePic,
    required this.name,
  });

  @override
  _ConversationScreenUIState createState() => _ConversationScreenUIState();
}

class _ConversationScreenUIState extends State<ConversationScreenUI> {
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.reference().child('Messages');

  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenForMessages();
  }

  void listenForMessages() {
    _messagesRef.child(widget.email).onChildAdded.listen((event) {
      // Handle received message
      final messageData = event.snapshot.value as Map<dynamic, dynamic>;
      final messageText = messageData['message'] as String;
      final messageSender = messageData['email'] as String;
      final messageTime =
          DateTime.fromMillisecondsSinceEpoch(messageData['time'] as int);

      // Create a MessageBubble for the received message
      final receivedMessage = MessageBubble(
        messageText: messageText,
        messageSender: messageSender,
        messageTime: messageTime,
        isMe: false,
        picture: widget.profilePic,
      );

      // Update the UI with the received message
      setState(() {
        messages.insert(0, receivedMessage);
      });
    });
  }

  void sendMessage(String messageText) {
    if (messageText.isNotEmpty) {
      _messagesRef.child(widget.email).push().set({
        'message': messageText,
        'time': DateTime.now().millisecondsSinceEpoch,
        'email': widget.email,
      }).then((_) {
        // Send notification to the other person using a server or cloud function
      });
      messageController.clear();

      // Create a MessageBubble for the sent message
      final sentMessage = MessageBubble(
        messageText: messageText,
        messageSender: widget.email,
        messageTime: DateTime.now(),
        isMe: true,
        picture: widget.profilePic,
      );

      // Update the UI with the sent message
      setState(() {
        messages.insert(0, sentMessage);
      });
    }
  }

  List<MessageBubble> messages = [];

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
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return messages[index];
                },
              ),
            ),
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
                  IconButton(
                    onPressed: () {
                      final messageText = messageController.text.trim();
                      sendMessage(messageText);
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

class MessageBubble extends StatelessWidget {
  final String messageText;
  final String messageSender;
  final DateTime messageTime;
  final bool isMe;
  final String picture;

  const MessageBubble({
    Key? key,
    required this.messageText,
    required this.messageSender,
    required this.messageTime,
    required this.isMe,
    required this.picture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(picture),
                    radius: 15,
                  ),
                ),
              Material(
                shadowColor: Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                elevation: 5.0,
                color: isMe ? Colors.purple[100] : Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  child: Text(
                    messageText,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
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
            // Messages widget
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
