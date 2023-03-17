import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/main.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';

import '../../../routes/app_pages.dart';

class AuthController extends ChangeNotifier {

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final birthdayController = TextEditingController();
  final ageController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  
  FirebaseAuth auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
  
  File? userImageFile;

  //*****CREATE USER IN FIRESTORE*****/
  Future signin(context) async{
    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try { 
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
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

  Future signup(context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .whenComplete(() {
          userCreateProfile(
            username: userNameController.text, 
            email: emailController.text,
            birthday: DateTime.parse(selectedDate.toString()),
            age: ageController.text,
            // userurl: authController.userImageFile!,
          );
        });
    } on FirebaseAuthException catch (e){
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  //*****SIGNOUT*****/
  Future signOut() async  {
     await FirebaseAuth.instance.signOut().whenComplete(() {
      Get.toNamed(Routes.AUTH);
      Get.snackbar("Déconnexion réussie", "A bientôt!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[500],
      );
    });
  }

  //*****RESETPASSWORD*****/
  Future resetPassword(context) async{
    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  
    try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.toString())
      .whenComplete(() {
        Utils.showSnackBar("Email envoyer!");
         Navigator.of(context).popUntil((route) => route.isFirst);
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    initState();
    notifyListeners();
  }

  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  void close(){
    emailController.clear();
    passwordController.clear();
    close();
  }

}