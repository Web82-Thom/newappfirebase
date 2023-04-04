import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newappfirebase/helper/constants.dart';
import 'package:newappfirebase/helper/helperfunctions.dart';
import 'package:newappfirebase/modules/auth/views/auth_view.dart';
import 'package:newappfirebase/modules/chat/controller/chat_controller.dart';
import 'package:newappfirebase/modules/chat/views/chat.dart';
import 'package:newappfirebase/modules/chat/widgets/widget.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  ChatController chatController = ChatController();
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController searchEditingController = TextEditingController();
  QuerySnapshot? searchResultSnapshot;
  User? user;
  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await chatController.searchByName(searchEditingController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList(){
    return 
    // haveUserSearched ? 
    searchResultSnapshot != null ?
    ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot!.docs.length,
        itemBuilder: (context, index){
        return userTile(
          searchResultSnapshot!.docs[index]["username"],
          searchResultSnapshot!.docs[index]["email"],
        );
      }
    ) 
    : Container(
      margin: EdgeInsets.all(20),
      child: const Center(
        child: Text("Rechercher"),),
    );
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName){
    List<String> users = [Constants.myName,userName];

    String chatRoomId = getChatRoomId(Constants.myName,userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    chatController.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Chat(
        chatRoomId: chatRoomId,
      )
    ));

  }

  Widget userTile(String userName,String userEmail){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              )
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){
                  print(userName);
                  print(Constants.myName);
                userName != Constants.myName ?
                sendMessage(userName):
                Utils.showSnackBar("Tu ne peux pas communiquer avec toi... trouve-toi un ami (e)... :)");
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: const Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }


  getChatRoomId(String? a, String? b) {
    if (a!.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
      return "${b}_$a";
    } else {
      return "${a}_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chercher un membre...")),
      body: isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) :  Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: const Color(0x54FFFFFF),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchEditingController,
                    style: simpleTextStyle(),
                    decoration: const InputDecoration(
                      hintText: "Chercher avec un prénom...",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      border: InputBorder.none
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    initiateSearch();
                  },
                  child: Container(
                    height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF)
                          ],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight
                        ),
                        borderRadius: BorderRadius.circular(40)
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.search, size: 25 ),
                        ),
                )
              ],
            ),
          ),
          userList()
        ],
      ),
    );
  }
}


