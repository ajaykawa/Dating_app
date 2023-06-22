import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../model/chatModel.dart';
import '../chat_components/conversation_screen_ui.dart';

class ChatScreenUi extends StatefulWidget {
  const ChatScreenUi({Key? key}) : super(key: key);
  @override
  State<ChatScreenUi> createState() => _ChatScreenUiState();
}

class _ChatScreenUiState extends State<ChatScreenUi>
    with SingleTickerProviderStateMixin {
  final firebaseAuth = FirebaseAuth.instance;
  late final String currentUserId;
  late List<User> users;
  RxInt currentIndex = 0.obs;
  int? tappedIndex;
  Timer? _timer;
  String chatid = "";
  @override
  void initState() {
    final firebaseUser = firebaseAuth.currentUser;
    currentUserId = firebaseUser!.uid;
    users = [];
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // Check if there are more chat items to display
      if (currentIndex < dummyData.length) {
        setState(() {
          currentIndex++;
        });
      } else {
        _timer?.cancel(); // Cancel the timer when all chat items are displayed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = firebaseAuth.currentUser!;
    final userId = firebaseUser.uid;
    return Expanded(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var usersss =
              userData.containsKey('Match_with') ? userData['Match_with'] : [];
          if (usersss.isEmpty) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: ListView.builder(
                itemCount: currentIndex.value,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  final item = dummyData[i];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FakeChat(
                                email: item.name!,
                                name: item.name!,
                                profilePic: item.avatarUrl!,
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            item.avatarUrl!, // Assuming the first image is the profile picture
                          ),
                          radius: 26,
                          child: item.online!
                              ? Container(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.name!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              item.time!,
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
                                if (item.seen!)
                                  Icon(
                                    Icons.done_all,
                                    size: 18,
                                    color: Colors.blue[600],
                                  ),
                                const SizedBox(width: 5),
                                Text(
                                  item.message!,
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
                              thickness: 2,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            );
          }
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: containerRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
              child: ListView.builder(
                itemCount: usersss.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(usersss[i])
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(); // You can show a placeholder or loading state
                      }
                      var userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      var imageUrl = userData[
                          'images']; // Assuming you have a field 'profileImageUrl' in the user document
                      var name = userData['username'];
                      return Column(
                        children: [
                          ListTile(
                            onTap: () async {
                              Map<Object, Object?> user1 = {};
                              String? token =
                                  await FirebaseMessaging.instance.getToken();
                              print(
                                  '///////////////////${userData['mychats']}');
                              print(
                                  '...................${'${currentUserId}${usersss[i]}'}');

                              if (userData['mychats']
                                  .contains('${currentUserId}${usersss[i]}')) {
                                chatid = '${currentUserId}${usersss[i]}';
                              } else if (userData['mychats']
                                  .contains('${usersss[i]}${currentUserId}')) {
                                chatid = '${usersss[i]}${currentUserId}';
                              } else {
                                user1 = {
                                  'mychats': FieldValue.arrayUnion(
                                      ["${currentUserId}${usersss[i]}"]),
                                };
                                chatid = "${currentUserId}${usersss[i]}";
                              }
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUserId)
                                  .update(user1);
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(usersss[i])
                                  .update(user1);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Chat(
                                        usersss[i],
                                        token!,
                                        currentUserId,
                                        chatid,
                                        name,
                                        imageUrl[i]),
                                  ));
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                imageUrl.isNotEmpty
                                    ? imageUrl[i]
                                    : '', // Assuming the first image is the profile picture
                              ),
                              radius: 26,
                              child: dummyData[i].online!
                                  ? Container(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  name ?? '',
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
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class User {
  String id;
  String username;
  List<String> images;

  User({required this.id, required this.username, required this.images});
}
