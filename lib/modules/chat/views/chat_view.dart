import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:newappfirebase/modules/chat/widgets/messages.dart';
import 'package:newappfirebase/modules/chat/widgets/new_message.dart';


class ChatView extends StatefulWidget {
  const ChatView({super.key});

  
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  @override
  void initState()  {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    // construction d'une liste de message dans le ctx et index dans un container
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thom t\'chat'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: const <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Déconnexion'),
                  ],
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: const <Widget>[
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
