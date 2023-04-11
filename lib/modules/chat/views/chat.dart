import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newappfirebase/helper/constants.dart';
import 'package:newappfirebase/modules/chat/controller/chat_controller.dart';
import 'package:newappfirebase/modules/chat/widgets/message_tile_widget.dart';
import 'package:newappfirebase/modules/chat/widgets/widget.dart';

class Chat extends StatefulWidget {
  final String? chatRoomId;

  const Chat({super.key, this.chatRoomId});

  @override
  // ignore: library_private_types_in_public_api
  _ChatState createState() => _ChatState();
}
ChatController chatController = ChatController();

class _ChatState extends State<Chat> {

  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = TextEditingController();

  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
            return MessageTile(
              username: snapshot.data!.docs[index]["username"],
              url: snapshot.data!.docs[index]["imageUrl"],
              message: snapshot.data!.docs[index]["message"],
              sendByMe: Constants.myName == snapshot.data!.docs[index]["sendBy"],
            );
          },
        ) 
        : Container();
      },
    );
  }

  addMessage() async{
    FocusScope.of(context).unfocus();
    final user =  FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageData = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        "imageUrl" : userData['url'],
        "username" : userData["username"],
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      chatController.addMessage(widget.chatRoomId!, chatMessageData);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    chatController.getChats(widget.chatRoomId!).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Stack(
        children: [
          chatMessages(),
          Container(alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              color: const Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageEditingController,
                      style: simpleTextStyle(),
                      decoration: const InputDecoration(
                        hintText: "Message ...",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  const SizedBox(width: 16,),
                  IconButton(
                    onPressed: () {
                      addMessage();
                    }, 
                    icon: const Icon(Icons.send,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



