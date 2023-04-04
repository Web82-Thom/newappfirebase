
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/helper/constants.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';

class ChatController{

  getChatRoomId(String? a, String? b) {
    if (a!.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
      return "${b}_$a";
    } else {
      return "${a}_$b";
    }
  }

  sendMessage(String userName){
    List<String> users = [Constants.myName,userName];

    String chatRoomId = getChatRoomId(Constants.myName,userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    addChatRoom(chatRoom, chatRoomId);
  }

  Future<void> addChatRoom(chatRoom, chatRoomId) async{
    await FirebaseFirestore.instance
      .collection("chatRoom")
      .doc(chatRoomId)
      .set(chatRoom)
      .catchError((e) {
      Utils.showSnackBar(e);
    });
  }

  Future<void> addMessage(String chatRoomId, chatMessageData)async {
    try {
      FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData);
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
      .collection("users")
      .where('username', isEqualTo: searchField)
      .get();
  }

  getChats(String chatRoomId) async{
    return FirebaseFirestore.instance
      .collection("chatRoom")
      .doc(chatRoomId)
      .collection("chats")
      .orderBy('time')
      .snapshots();
  }

  getUserChats(String itIsMyName) async {
    try {
      return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }
  
  Future deleteChatRoom(chatRoomId) async{
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection = instance.collection('chatRoom').doc(chatRoomId).collection("chats");
    var snapshots = await collection.get().whenComplete(() => 
    FirebaseFirestore.instance.collection('chatRoom').doc(chatRoomId).delete(),
    );
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    
  }

  final chatRoomCollection = FirebaseFirestore.instance.collection("chatRoom");
  Future updateUsernameInChatRoom({required String id, required String username}) async {
    try {
      chatRoomCollection.doc(id).update({
        "username": username,
      }).whenComplete(() {
        // readUser();
        Get.snackbar(
          "Modification réussie",
          "Votre nom d'utilisateur a bien été modifiée !",
          snackPosition: SnackPosition.BOTTOM,
        );
        // notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

}