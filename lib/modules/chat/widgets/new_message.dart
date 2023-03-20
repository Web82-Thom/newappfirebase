import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async  {
    FocusScope.of(context).unfocus();
    // final _auth = await FirebaseAuth.instance;
    final user =  FirebaseAuth.instance.currentUser;
    // final _data = await FirebaseFirestore.instance;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'createdAt' : Timestamp.now(),
      'text': _enteredMessage,
      'username' : userData['username'],
      // 'userImage': userData['imageUrl'],
      'userId': user.uid,
    });
    _controller.clear();
    // print(userData['imageUrl']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:8,),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Laisser un méssage...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage, 
            icon: Icon(Icons.send), 
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}