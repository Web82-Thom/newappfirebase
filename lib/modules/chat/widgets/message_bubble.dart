import 'package:flutter/material.dart';

      ////////////////////////////////
      // CHAT BUBBLE IN GENERAL CHAT//
      ////////////////////////////////

class MessageBubble extends StatelessWidget {
  final Key? key;
  final String? text;
  final String? userName;
  final String? userImage;
  final bool? isMe;
  
  const MessageBubble(
    this.text,
    this.userName,
    this.userImage,
    this.isMe, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment: isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: isMe! ? Colors.grey[300] : Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe! ? const Radius.circular(0) : const Radius.circular(12),
                  bottomRight: !isMe! ? const Radius.circular(0) : const Radius.circular(12),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    isMe! ? 'Moi' : userName!,
                    style: TextStyle(
                      color: isMe!
                        ? Colors.green
                        : Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    text!,
                    style: TextStyle(
                      color: isMe!
                        ? Colors.black
                        : Colors.white,
                    ),
                    textAlign: isMe! ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: isMe! ? null : 130,
          right: isMe! ? 130 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage!),
          ),
        ),
      ], //overflow
    );
  }
}
