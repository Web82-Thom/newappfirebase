import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/helper/constants.dart';
import 'package:newappfirebase/helper/helperfunctions.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/modules/chat/widgets/chatRoomsTile_widget.dart';
import 'package:newappfirebase/modules/chat/widgets/search.dart';
import 'package:newappfirebase/modules/profile/controllers/profile_controller.dart';
import 'package:newappfirebase/ressources/firebaseApi/firebaseapi.dart';
import 'package:newappfirebase/ressources/firebaseApi/firebasefile.dart';
import 'package:newappfirebase/routes/app_pages.dart';
import '../controller/chat_controller.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late Future<List<FirebaseFile>> futureFiles;
  late Future<List<UserModel>> userModel;
  @override
  void initState(){
    super.initState();
    getUserInfogetChats();
    profileController.getAllMembers();
    profileController.members;
    futureFiles = FirebaseApi.listAll('user_image/');
  }
  Stream? chatRooms;
  bool isList = true;
  ProfileController profileController = ProfileController();
  ChatController chatController = ChatController();
  UserModel? user;

  Widget chatRoomsList() {
    return 
    StreamBuilder(
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
                        .replaceAll(Constants.myName, ""),
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
        final items = snapshot.data;
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData || items != null){
            return ListView.builder(
              itemCount:items!.length,
              itemBuilder: (ctx, index){
                final file = items[index];
                return Slidable(
                  startActionPane: ActionPane(
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
                        trailing: CircleAvatar(
                          
                        ),
                        title: Text(snapshot.data![index].username.toString()),
                      ),
                      const SizedBox(height: 12,)
                    ],
                  ),
                );
              },
            );
          } 
        } return const Center(child: Text("aucun membre"),);
      } 
    );
  }

  // Widget contactList() {
  //   return FutureBuilder<List<FirebaseFile>>(
  //     future: futureFiles,
  //     builder: (context, snapshot){
  //       final items = snapshot.data;
  //       if(snapshot.connectionState == ConnectionState.done){
  //         if(snapshot.hasData || items != null){
  //           return ListView.builder(
  //             itemCount:items!.length,
  //             itemBuilder: (ctx, index){
  //               final file = items[index];
  //               return Slidable(
  //                 startActionPane: ActionPane(
  //                   motion: const StretchMotion(), 
  //                   children: [
  //                     SlidableAction(
  //                       onPressed: (context){
  //                         Get.toNamed(Routes.USERINFOS);
  //                       },
  //                       backgroundColor: Colors.green, 
  //                       icon: Icons.remove_red_eye_sharp,
  //                       label: 'Détails',
  //                     ),
  //                     SlidableAction(
  //                       onPressed: (context){
  //                         // ignore: avoid_print
  //                         print("Signaler");
  //                       },
  //                       backgroundColor: Colors.orange, 
  //                       icon: Icons.remove_red_eye_sharp,
  //                       label: 'Signaler',
  //                     ),
  //                   ], 
  //                 ),
  //                 endActionPane: ActionPane(
  //                   motion: const StretchMotion(), 
  //                   children: [
  //                     SlidableAction(
  //                       onPressed: (context){
  //                         // ignore: avoid_print
  //                         print("ajouter aux amis");
  //                       },
  //                       backgroundColor: Colors.amber, 
  //                       icon: Icons.add,
  //                       label: 'Ajouter aux amis',
  //                     ),
  //                   ], 
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     ListTile(
  //                       hoverColor: Colors.green,
  //                       splashColor: Colors.amber,
  //                       textColor: Colors.white,
  //                       trailing: CircleAvatar(backgroundImage: NetworkImage(file.url),
  //                         ),
  //                       title: Text(file.name.toString()),
  //                     ),
  //                     const SizedBox(height: 12,)
  //                   ],
  //                 ),
  //               );
  //             },
  //           );
  //         } 
  //       } return const Center(child: Text("aucun membre"),);
  //     } 
  //   );
  // }

  Future getUserInfogetChats() async {
    // Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    chatController.getUserChats(Constants.myName).then((snapshots) {
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


