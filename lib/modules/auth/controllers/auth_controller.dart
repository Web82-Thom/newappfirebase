import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';

import '../../../routes/app_pages.dart';

class AuthController extends ChangeNotifier {
  
  // bool isSignUp = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
  
  File? userImageFile;

  //*****CREATE USER IN FIRESTORE*****/
  void userCreateProfile({
    required String username,
    required String email,
    required DateTime birthday,
    required String age,
    // required File userurl,
  }) async{
    usersCollection
    .doc(auth.currentUser!.uid)
    .set(UserModel(
        id: auth.currentUser!.uid,
        username: username,
        email: email,
        birthday: birthday,
        age: age,
        // url: userurl.path,
      ).toMap(),
    ).catchError((error) =>
      print("Failed to add user : $error"),
    );
  }

  @override
  void initState() {
    initState();
    notifyListeners();
  }

  @override
  void onReady() {
    onReady();
  }

  @override
  void close() {
    close();
  }

}