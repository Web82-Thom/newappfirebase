import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/helper/helperfunctions.dart';
import 'package:newappfirebase/main.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';
import '../../../routes/app_pages.dart';

class AuthController extends ChangeNotifier {
  AuthController();
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
     UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text);
        User? user = result.user;
        QuerySnapshot userInfoSnapshot =
          await getUserInfo(emailController.text);

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(
          userInfoSnapshot.docs[0]["username"]);
        HelperFunctions.saveUserEmailSharedPreference(
          userInfoSnapshot.docs[0]["email"]);
    } on FirebaseAuthException catch (e) {
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
      Utils.showSnackBar(error),
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
        email: emailController.text, password: passwordController.text).then((value) {
          getUserInfo(emailController.text);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(userNameController.text);
          HelperFunctions.saveUserEmailSharedPreference(emailController.text);
        })
        .whenComplete(() {
          userCreateProfile(
            username: userNameController.text, 
            email: emailController.text,
            birthday: DateTime.parse(selectedDate.toString()),
            age: ageController.text,
            // userurl: authController.userImageFile!,
          );
        },
              
        );
    } on FirebaseAuthException catch (e){
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  //*****SIGNOUT*****/
  Future signOut() async  {
     await FirebaseAuth.instance.signOut().whenComplete(() {
      emailController.clear();
      passwordController.clear();
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

  getUserInfo(String email) async {
    try {
      FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  void initState() {
    initState();
    notifyListeners();
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  void close(){
    emailController.clear();
    passwordController.clear();
    close();
  }
  
}