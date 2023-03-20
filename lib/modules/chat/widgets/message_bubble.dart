import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
    this.text,
    this.userName,
    // this.userImage,
    this.isMe, {
    this.key,
  });

  final Key? key;
  final String? text;
  final String? userName;
  // final String? userImage;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: isMe! ? Colors.grey[300] : Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe! ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: !isMe! ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
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
                          ? Colors.black
                          : Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    text!,
                    style: TextStyle(
                      color: isMe!
                          ? Colors.black
                          : Colors.amber,
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
            // backgroundImage: NetworkImage(userImage!),
            backgroundImage: NetworkImage("https://png.pngtree.com/background/20210709/original/pngtree-technology-network-it-poster-banner-background-picture-image_864222.jpg"),
          ),
        ),
      ],
      clipBehavior: Clip.none, //overflow
    );
  }
}
