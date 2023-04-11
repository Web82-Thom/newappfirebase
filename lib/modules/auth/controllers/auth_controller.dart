import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  XFile? file;
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  User? user;

  FirebaseAuth auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  UserModel? _userFromFirebaseUser(User? user){
    return user != null ? UserModel(
      id: user.uid,) : null;
  }

  bool _isLoading = false;
  bool get isloading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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
        user = result.user;
        getUserProfile();
        _userFromFirebaseUser(user);
        notifyListeners();
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
    required File? url,
    required String userToken,
    required Timestamp createdAt,
  }) async{
    usersCollection
    .doc(auth.currentUser!.uid)
    .set(
      UserModel(
        id: auth.currentUser!.uid,
        username: username,
        email: email,
        birthday: birthday,
        url: file!.path ,
        userToken : userToken,
        createdAt: Timestamp.now(),
      ).toMap(),
    ).catchError((error) =>
      Utils.showSnackBar(error),
    );
  }

  Future signup({
    required String name,
    required String email,
    required String password,
    required DateTime birthday,
    required String url,
  }) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    try {
      UserCredential result =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text
      );
      user = auth.currentUser;
      usersCollection
        .doc(user!.uid)
        .set(
          UserModel(
            id: user!.uid,
            email: email,
            username: name,
            birthday: birthday,
            url: url,
          ).toMap(),
        );
      userCreateProfile(
        username: userNameController.text, 
        email: emailController.text,
        birthday: DateTime.parse(selectedDate.toString()),
        url: File(userImageFile!.path),
        userToken: auth.currentUser!.uid,
        createdAt: Timestamp.now(),
      );
      //send image//
      uploadImage();
      getUserProfile();
      _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e){
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
  
  Future uploadImage() async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('user_image');
    Reference referenceImageToUpload = referenceDirImages.child('${auth.currentUser!.uid}.png');
      try {
      await referenceImageToUpload.putFile(File(file!.path));
      final imageURL = await referenceImageToUpload.getDownloadURL();
        
      FirebaseFirestore.instance.collection("users")
        .doc(auth.currentUser!.uid)
        .update({'url': imageURL})
        .whenComplete(() {
          // downloadURLCurrentUser();
          setIsLoading(false);
          notifyListeners();
          Utils.showSnackBar('Image modifier');
        },
      );
    }  catch (error) {
      Utils.showSnackBar(error.toString());
    }
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
      } else {
        Utils.showSnackBar('Document does not exist on the database');
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