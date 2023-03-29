import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newappfirebase/modules/chat/widgets/message_bubble.dart';


class Messages extends StatelessWidget {
  const Messages({super.key});


  Future curUser() async {
    // User useid=  
    FirebaseAuth.instance.currentUser;
    // print('cest $useid');
    // print(useid.displayName);
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser!;
    return FutureBuilder(
      future: curUser(),
      builder:(ctx, futureSnapshot) { 
        if (futureSnapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true,).snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data!.docs;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                chatDocs[index]['text'],
                chatDocs[index]['username'],
                // chatDocs[index]['userImage'],
                chatDocs[index]['userId'] == currentUser.uid,
                key: ValueKey(chatDocs[index].data()['documentID']),
              ),
            );
          },
        );
      },
    );
  }
}
