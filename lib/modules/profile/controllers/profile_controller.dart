import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';

class ProfileController extends ChangeNotifier {

  FirebaseAuth auth = FirebaseAuth.instance;

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
}