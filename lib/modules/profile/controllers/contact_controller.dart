import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';

class ContactController extends ChangeNotifier {
  ContactController();
  List<UserModel> contactlist = <UserModel>[];
  // final ContactState state = ContactState();
  final firestore = FirebaseFirestore.instance;
  // final token = UserStore.to.token;
   String uidSelected = "";
   String nameSelected = "";

  void onReady() {
    onReady();
    asyncLoadData();
    notifyListeners();
  }

  Future asyncLoadData() async {
    var userBase = await firestore.collection("users").withConverter(
      fromFirestore: UserModel.fromFirestore, 
      toFirestore: (UserModel userModel, options)=>userModel.toFirestore()).get();

    for(var doc in userBase.docs){
      contactlist.add(doc.data());
      notifyListeners();
    }
    notifyListeners();
  }

  // Future goChat(UserModel toUserdata) async{
    
  //   final fromMessages = await firestore.collection("message")
  //   .withConverter(
  //     fromFirestore: Msg.fromFirestore, 
  //     toFirestore: (Msg msg, options)=>msg.toFirestore())
  //     .where(
  //       "from_uid", isEqualTo: auth.currentUser!.uid)
  //       .where(
  //     "to_uid", isEqualTo: toUserdata.id)
  //     .get();

  //   final toMessages = await firestore.collection("message")
  //   .withConverter(
  //     fromFirestore: Msg.fromFirestore, 
  //     toFirestore: (Msg msg, options)=>msg.toFirestore()
  //     ).where(
  //       "from_uid", isEqualTo: toUserdata.id
  //     ).where(
  //       "to_uid", isEqualTo: auth.currentUser!.uid
  //     ).get();
      
  //     if(fromMessages.docs.isEmpty && toMessages.docs.isEmpty){
  //       final msgdata = Msg(
  //         from_uid: auth.currentUser!.uid,
  //         from_name: auth.currentUser!.displayName,
  //         to_uid: uidSelected ,
  //         to_name: nameSelected,
  //       );
  //       Msg addMsgData = msgdata ;
  //       firestore.collection("message").withConverter(
  //         fromFirestore: Msg.fromFirestore, 
  //         toFirestore: (Msg msg, options)=>msg.toFirestore()
  //       ).add(addMsgData);
  //     } else {
  //       if(fromMessages.docs.isNotEmpty){
  //         Get.toNamed(Routes.CHATVIEW, parameters: {
  //           "doc_id": fromMessages.docs.first.id,
  //         "to_uid": toUserdata.id??"",
  //         "to_name": toUserdata.username??"",
  //         });
  //       } 
  //       if(toMessages.docs.isNotEmpty){
  //         Get.toNamed(Routes.CHATVIEW, parameters: {
  //           "doc_id": toMessages.docs.first.id,
  //           "to_uid": toUserdata.id??"",
  //           "to_name": toUserdata.username??"",
  //         });
  //       } 
  //     }
  // }
}