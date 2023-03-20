import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/modules/home/views/home_view.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';
import 'package:newappfirebase/routes/app_pages.dart';

class ProfileController extends ChangeNotifier {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore authStore = FirebaseFirestore.instance;
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  //READ ONE USER
  Future<UserModel?> readUser() async {
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data()!);
    }
    return Utils.showSnackBar('erreur');
  }

  //READ ALL USERS
  Future<List<UserModel>> readAllUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users").where("email", isNotEqualTo: auth.currentUser!.email).get();
    final usersData =  snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    if (usersData.isEmpty) {
      return Utils.showSnackBar('erreur');
    }return usersData;
  }

  Future updateUsername({ 
    required String id, 
    required String username
  }) 
  async{
    try {
      usersCollection
      .doc(id)
      .update({
        "username": username,
      }).whenComplete(() {
        profileController.readUser();
        Get.snackbar(
          "Modification réussie",
          "Votre nom d'utilisateur a bien été modifiée !", 
          snackPosition: SnackPosition.BOTTOM,
        );
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  Future updateEmail({required String id, required String email}) async {
    try {
      await usersCollection.doc(id).update({
        "email": email,
      }).whenComplete(() {
        profileController.readUser();
        Get.snackbar("Modification réussie",
            "Votre email a bien été modifiée !",
            snackPosition: SnackPosition.BOTTOM);
      });
    } catch (e) {
      print(e);
    }
  }
  Future updateAge({required String id, required String age}) async {
    try {
      await usersCollection.doc(id).update({
        "age": age,
      }).whenComplete(() {
        profileController.readUser();
        Get.snackbar("Modification réussie",
            "Votre age a bien été modifiée !",
            snackPosition: SnackPosition.BOTTOM);
      });
    } catch (e) {
      print(e);
    }
  }

  Future updateBirthday({required String id, required DateTime birthday}) async {
    try {
      await usersCollection.doc(id).update({
        "birthday": birthday,
      }).whenComplete(() {
        profileController.readUser();
        Get.snackbar("Modification réussie",
            "Votre date de naissance a bien été modifiée !",
            snackPosition: SnackPosition.BOTTOM);
      });
    } catch (e) {
      print(e);
    }
  }

  Future userDeleteAccount({required String id}) async {
    await usersCollection.doc(id).delete().whenComplete(() {
      FirebaseAuth.instance.currentUser!.delete();
      Get.toNamed(Routes.AUTH);
      Get.snackbar("Suppression réussie",
          "Votre compte a bien été supprimé. On espère vous revoir bientôt !",
          snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[500],
        );
    });
  }

  UserModel? _userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("user not found");
    return UserModel(
      id: snapshot.id,
      username: data['name'],
      email: data['email'],
      birthday: data['birthday'],
      age: data['age'],
    );
  }

  final CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection("users");


 List<UserModel?> _userListFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
     return snapshot.docs.map((doc) {
       _userFromSnapshot(doc);
    }).toList();
  }
  Stream<List<UserModel?>> get user {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

 

  
    
}