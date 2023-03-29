import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/helper/constants.dart';
import 'package:newappfirebase/helper/helperfunctions.dart';
import 'package:newappfirebase/modules/chat/widgets/chatRoomsTile_widget.dart';
import 'package:newappfirebase/modules/chat/widgets/search.dart';
import 'package:newappfirebase/modules/profile/controllers/profile_controller.dart';
import 'package:newappfirebase/routes/app_pages.dart';
import '../controller/chat_controller.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream? chatRooms;
  bool isList = true;
  ProfileController profileController = ProfileController();
  ChatController chatController = ChatController();

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData? 
          ListView.builder(
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Slidable(
                    endActionPane: ActionPane(
                    motion: const StretchMotion(), 
                    children: [
                      SlidableAction(
                        onPressed: (context){
                          chatController.deleteChatRoom(snapshot.data.docs[index]['chatRoomId']);
                        },
                        backgroundColor: Colors.red, 
                        icon: Icons.add,
                        label: 'Supprimer',
                      ),
                    ], 
                  ),
                    child: ChatRoomsTileWidget(
                      userName: snapshot.data.docs[index]['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName!, ""),
                      chatRoomId: snapshot.data.docs[index]["chatRoomId"],
                    ),
                  ),
                  const SizedBox(height: 12,)
                ],
              );
            },
          )
          : 
          Center(
            child: Column(
            children: const [
              CircularProgressIndicator(), 
              Text("Conversation vide"),
            ],
          ),
        );
      }
    );
  }

  Widget contactList() {
    return FutureBuilder(
      future: profileController.readAllUsers(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            final item = snapshot.data;
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index){
                return Slidable(
                  startActionPane: 
                  ActionPane(
                    motion: const StretchMotion(), 
                    children: [
                      SlidableAction(
                        onPressed: (context){
                          Get.toNamed(Routes.USERINFOS);
                        },
                        backgroundColor: Colors.green, 
                        icon: Icons.remove_red_eye_sharp,
                        label: 'Détails',
                      ),
                      SlidableAction(
                        onPressed: (context){
                          // ignore: avoid_print
                          print("Signaler");
                        },
                        backgroundColor: Colors.orange, 
                        icon: Icons.remove_red_eye_sharp,
                        label: 'Signaler',
                      ),
                    ], 
                  ),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(), 
                    children: [
                      SlidableAction(
                        onPressed: (context){
                          // ignore: avoid_print
                          print("ajouter aux amis");
                        },
                        backgroundColor: Colors.amber, 
                        icon: Icons.add,
                        label: 'Ajouter aux amis',
                      ),
                    ], 
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        hoverColor: Colors.green,
                        splashColor: Colors.amber,
                        textColor: Colors.white,
                        trailing: const CircleAvatar(),
                        title: Text(snapshot.data![index].username.toString()),
                      ),
                      const SizedBox(height: 12,)
                    ],
                  ),
                );
              },
            );
          }
        }return Container();
      } 
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    chatController.getUserChats(Constants.myName!).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.black),
    onPressed: () => Navigator.of(context).pop(),
  ), 
        automaticallyImplyLeading: true,
        title: const Text("Communautés"),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(onPressed: (){
              setState(() {
                isList = !isList;
              });
            }, child: 
            
            Text("Liste des membres", style: TextStyle(color: isList? Colors.white : Colors.grey),)
            
            ),
              TextButton(onPressed: (){
              setState(() {
                isList = !isList;
              });
            }, child: 
            Text("Liste des conversation", style: TextStyle(color: isList? Colors.grey : Colors.white))
            ),
            ],
          ),
          isList ? 
          Expanded(
            child: contactList(),
          )
          : 
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width, 
              // color: Colors.yellow, 
              child: chatRoomsList(),),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Search()));
        },
      ),
    );
  }
}


