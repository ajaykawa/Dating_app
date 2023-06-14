import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../model/messageModel.dart';
import 'messageBox.dart';

class BottomSendNavigation extends StatefulWidget {

  @override
  _BottomSendNavigationState createState() => _BottomSendNavigationState();
}

class _BottomSendNavigationState extends State<BottomSendNavigation>
    with SingleTickerProviderStateMixin {
  final TextEditingController _sendMessageController = TextEditingController();

  bool showEmoji = false;

  FocusNode focusNode = FocusNode();

  Icon _emojiIcon = const Icon(
    FontAwesomeIcons.faceSmileWink,
    color: Colors.grey,
    size: 20,
  );

  @override
  void initState() {
    super.initState();
    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          setState(() {
            showEmoji = true;
            _emojiIcon = const Icon(
              FontAwesomeIcons.faceSmile,
              color: Colors.grey,
              size: 20,
            );
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('messages').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                reverse: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: messages.map((message) {
                  return MessageBox(
                    isMe: message.isMe,
                    message: message.message,
                  );
                }).toList(),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 80,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showEmoji = !showEmoji;
                            if (showEmoji) {
                              _emojiIcon = const Icon(
                                FontAwesomeIcons.keyboard,
                                color: Colors.grey,
                                size: 20,
                              );
                              focusNode.unfocus();
                            } else {
                              _emojiIcon = const Icon(
                                FontAwesomeIcons.faceSmile,
                                color: Colors.grey,
                                size: 20,
                              );
                              focusNode.requestFocus();
                            }
                          });
                        },
                        icon: _emojiIcon,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _sendMessageController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            sendMessage();
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: sendMessage,
                        icon: const Icon(
                          FontAwesomeIcons.paperPlane,
                          color: Colors.purple,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // showEmoji ? emojiSelect() : Container(),
            ],
          ),
        ],
      ),
    );
  }

  // Widget emojiSelect() {
  //   return EmojiPicker(
  //     key: 3,
  //     columns: 7,
  //     buttonMode: ButtonMode.MATERIAL,
  //     onEmojiSelected: (emoji, category) {
  //       setState(() {
  //         _sendMessageController.text =
  //             _sendMessageController.text + emoji.emoji;
  //       });
  //     },
  //   );
  // }

  Future<bool> onBackPress() {
    if (showEmoji) {
      setState(() {
        showEmoji = false;
        _emojiIcon = const Icon(
          FontAwesomeIcons.faceSmileWink,
          color: Colors.grey,
          size: 20,
        );
      });
    } else {
      Navigator.of(context).pop(true);
    }
    return Future.value(false);
  }

  void sendMessage() {
    if (_sendMessageController.text.isNotEmpty) {
      final message = MessageBox(
        message: _sendMessageController.text,
        isMe: true,
      );
      FirebaseFirestore.instance.collection('messages').add(message.toMap());
      setState(() {
        _sendMessageController.clear();
      });
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    _sendMessageController.dispose();
    super.dispose();
  }
}
