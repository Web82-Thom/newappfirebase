import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/helper/constants.dart';
import 'package:newappfirebase/main.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/modules/auth/widgets/signup_widget.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';
import '../../../routes/app_pages.dart';

class AuthController extends ChangeNotifier {
  AuthController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final birthdayController = TextEditingController();
  final ageController = TextEditingController();
  File? image;
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  User? user;
  FirebaseAuth auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
  // ImagePickerController imagePickerController = ImagePickerController();
  

  UserModel? _userFromFirebaseUser(User? user){
    return user != null ? UserModel(
      id: user.uid,
      username: user.displayName) : null;
  }

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
        getUserProfile();
        _userFromFirebaseUser(user);
        notifyListeners();

        
        print("user! == ${user!}");
        print("user!.displayName == ${user.displayName}");
        print("user!.displayName == ${tempUser["username"]}");

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
     File? url,
    required String userToken,
    required Timestamp createdAt,
  }) async{
    usersCollection
    .doc(auth.currentUser!.uid)
    .set(UserModel(
        id: auth.currentUser!.uid,
        username: username,
        email: email,
        birthday: birthday,
        age: age,
        url: "user_image/profile.png" ,
        userToken : userToken,
        createdAt: Timestamp.now(),
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
     UserCredential result =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text
        );
        User? user = result.user;
        userCreateProfile(
            username: userNameController.text, 
            email: emailController.text,
            birthday: DateTime.parse(selectedDate.toString()),
            age: ageController.text,
            // url: userImageFile!,
            userToken: auth.currentUser!.uid,
            createdAt: Timestamp.now(),
          );
          //send image//
          // imagePickerController.uploadImage(filePath:'${userImageFile!.path}.png', docId: auth.currentUser!.uid);
          getUserProfile();
          _userFromFirebaseUser(user);
          // notifyListeners();
          // getUserInfo(emailController.text);
          // HelperFunctions.saveUserLoggedInSharedPreference(true);
          // HelperFunctions.saveUserNameSharedPreference(userNameController.text);
          // HelperFunctions.saveUserEmailSharedPreference(emailController.text);
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

  var tempUser = {};
  void getUserProfile() {
    FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser?.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        tempUser = documentSnapshot.data() as Map;
        Constants.myName = tempUser['username'];
        notifyListeners();
        print('Document ressources: ${documentSnapshot.data()}');
        print('tempUser ressources: $tempUser');
        print( tempUser['username']);
        print( 'Constants.myName' + Constants.myName);

        
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void initState() {
    initState();
    getUserProfile();
    notifyListeners();
  }
  @override
void ready(){
  ready();
  getUserProfile();
}
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    getUserProfile();
    super.dispose();
  }
  void close(){
    emailController.clear();
    passwordController.clear();
    close();
  }
  
}