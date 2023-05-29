import 'package:flutter/material.dart';

import '../../../constants.dart';

class MessageBox extends StatelessWidget {
  final bool? isMe;
  final String? message;
  const MessageBox({
    super.key,
    this.isMe,
    this.message,
  });
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'isMe': isMe,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isMe!) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    message!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    message!,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
