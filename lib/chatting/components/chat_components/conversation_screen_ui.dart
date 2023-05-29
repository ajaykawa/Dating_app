import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Screens/profile_card.dart';

class chatpage extends StatefulWidget {
  String email;
  String chatName;
  String profilepic;
  chatpage(
      {required this.email, required this.chatName, required this.profilepic});
  @override
  _chatpageState createState() => _chatpageState(email: email);
}

class _chatpageState extends State<chatpage> {
  String email;
  _chatpageState({required this.email});

  final fs = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.purple.shade200,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CardDetails(
                            profile:widget.chatName,
                            pic : widget.profilepic
                        );
                      },
                    ),
                  );
                },
                child: CircleAvatar(
                    radius: 22.r,
                    backgroundColor: const Color(0xfff5f5f5),
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          widget.profilepic,
                        ),
                        radius: 20.r)),
              ),
              const SizedBox(width: 10),
              Text(
                widget.chatName,
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
          actions: [
            StreamBuilder(
              stream: fs
                  .collection('Messages')
                  .orderBy('time', descending: true)
                  .where('email', isEqualTo: widget.email)
                  .limit(1)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                final lastMessage = snapshot.data!.docs.first;
                final messageTime = lastMessage['time'] as Timestamp;
                final lastSeenTime = messageTime.toDate();
                final now = DateTime.now();
                final difference = now.difference(lastSeenTime);
                String lastSeenText;
                if (difference.inMinutes < 60) {
                  lastSeenText = 'online';
                } else if (difference.inDays == 0) {
                  lastSeenText = '${difference.inHours} hr ago';
                } else {
                  lastSeenText = 'last seen ${lastSeenTime.toString()}';
                }
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    lastSeenText,overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 12,color: Colors.yellow,fontWeight: FontWeight.w700
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.79,
                child: messages(email: email, pic: widget.profilepic),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: message,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.purple[100],
                          hintText: 'message',
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purple),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purple),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {},
                        onSaved: (value) {
                          message.text = value!;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (message.text.isNotEmpty) {
                          fs.collection('Messages').doc().set({
                            'message': message.text.trim(),
                            'time': DateTime.now(),
                            'email': email,
                          });

                          message.clear();
                        }
                      },
                      icon: const Icon(Icons.send_sharp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class messages extends StatefulWidget {
  String email;
  String pic;
  messages({required this.email, required this.pic});
  @override
  _messagesState createState() => _messagesState(email: email);
}

class _messagesState extends State<messages> {
  String email;
  _messagesState({required this.email});

  final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection('Messages')
      .orderBy('time')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("something is wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['message'];
          final messageSender = message['email'];
          final messageTime = message['time'] as Timestamp;
          final currentUser = widget.email;
          final messageBubble = MessageBubble(
            picture: widget.pic,
            messageText: messageText,
            messageSender: messageSender,
            messageTime: messageTime,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String messageText;
  final String messageSender;
  final Timestamp messageTime;
  final bool isMe;
  final String picture;
  const MessageBubble(
      {super.key,
      required this.messageText,
      required this.picture,
      required this.messageSender,
      required this.messageTime,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isMe ? "You" : messageSender,
            style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
                fontWeight: FontWeight.w600),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: isMe
                  ? Material(
                      shadowColor: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft:
                            isMe ? const Radius.circular(30.0) : Radius.zero,
                        topRight:
                            isMe ? Radius.zero : const Radius.circular(30.0),
                        bottomLeft: const Radius.circular(30.0),
                        bottomRight: const Radius.circular(30.0),
                      ),
                      elevation: 5.0,
                      color: isMe ? Colors.purple[100] : Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          messageText,
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(picture),
                              radius: 15.r),
                        ),
                        Material(
                          shadowColor: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: isMe
                                ? const Radius.circular(30.0)
                                : Radius.zero,
                            topRight: isMe
                                ? Radius.zero
                                : const Radius.circular(30.0),
                            bottomLeft: const Radius.circular(30.0),
                            bottomRight: const Radius.circular(30.0),
                          ),
                          elevation: 5.0,
                          color: isMe ? Colors.purple[100] : Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              messageText,
                              style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    )),
          // Text(
          //   messageTime.toDate().toString(),
          //   style: const TextStyle(
          //     fontSize: 12.0,
          //     color: Colors.black54,
          //   ),
          // ),
        ],
      ),
    );
  }
}
