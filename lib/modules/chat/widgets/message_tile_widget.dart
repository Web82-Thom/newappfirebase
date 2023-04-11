import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String? message;
  final String? username;
  final String? url;
  final bool? sendByMe;

  const MessageTile({
    super.key,
    this.username,
    required this.message, 
    required this.sendByMe, 
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return 
    Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment: sendByMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: sendByMe! ? Colors.grey[300] : Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !sendByMe! ? const Radius.circular(0) : const Radius.circular(12),
                  bottomRight: !sendByMe! ? const Radius.circular(0) : const Radius.circular(12),
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
                    sendByMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    sendByMe! ? 'Moi' : username!,
                    style: TextStyle(
                      color: sendByMe!
                        ? Colors.green
                        : Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    message!,
                    style: TextStyle(
                      color: sendByMe!
                        ? Colors.black
                        : Colors.white,
                    ),
                    textAlign: sendByMe! ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: sendByMe! ? null : 130,
          right: sendByMe! ? 130 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(url!),
          ),
        ),
      ], //overflow
    );
  }
}