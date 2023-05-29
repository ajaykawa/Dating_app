import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../model/chatModel.dart';
import '../chat_components/conversation_screen_ui.dart';

class ChatScreenUi extends StatefulWidget {
  const ChatScreenUi({Key? key}) : super(key: key);

  @override
  State<ChatScreenUi> createState() => _ChatScreenUiState();
}

class _ChatScreenUiState extends State<ChatScreenUi> {
  final firebaseAuth = FirebaseAuth.instance;
  late final String currentUserId;
  late List<User> users;
  @override
  void initState() {
    final firebaseUser = firebaseAuth.currentUser;
    currentUserId = firebaseUser!.uid;
    users = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = firebaseAuth.currentUser!;
    final userId = firebaseUser.uid;
    final DocumentReference user =
        FirebaseFirestore.instance.collection('users').doc(userId);

    final Stream<DocumentSnapshot> userStream = user.snapshots();

    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final docs = snapshot.data!.docs;
              users = docs
                  .where((doc) => doc.id != currentUserId)
                  .map((doc) => User(
                        id: doc.id,
                        username:
                            (doc.data() as Map<String, dynamic>)['username'] ??
                                '',
                        images: List<String>.from(
                            (doc.data() as Map<String, dynamic>)['images'] ??
                                []),
                      ))
                  .toList();

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: containerRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                  child: ListView.builder(
                      itemCount: users.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, i) {
                        final user = users[i] ;
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => chatpage(email: firebaseUser.phoneNumber.toString(),chatName: user.username.toString(),profilepic :user.images[i])
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  user.images[i],
                                ),
                                radius: 26,
                                child: dummyData[i].online!
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 40, right: 40),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.pinkAccent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    user.username,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    dummyData[i].time!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      if (dummyData[i].seen!)
                                        Icon(
                                          Icons.done_all,
                                          size: 18,
                                          color: Colors.blue[600],
                                        ),
                                      const SizedBox(width: 5),
                                      Text(
                                        dummyData[i].message!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              );
            }));
  }
}

class User {
  String id;
  String username;
  List<String> images;

  User({required this.id, required this.username, required this.images});
}
