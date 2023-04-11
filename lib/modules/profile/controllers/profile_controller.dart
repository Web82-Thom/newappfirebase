import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/modules/home/views/home_view.dart';
import 'package:newappfirebase/modules/profile/controllers/contact_controller.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';
import 'package:newappfirebase/routes/app_pages.dart';

class ProfileController extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore authStore = FirebaseFirestore.instance;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
  ContactController contactController = ContactController();
@override
  void dispose() {
    super.dispose();
    members.bindStream(getAllMembers());
  }
  // READ ONE USER
  Future<UserModel?> readUser(String id) async {
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .doc(id);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data()!);
    }
    return Utils.showSnackBar('erreur');
  }

  //READ ALL USERS
  Future<List<UserModel>> readAllUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isNotEqualTo: auth.currentUser!.email)
        .get();
    final usersData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    contactController.contactlist = usersData;
    if (usersData.isEmpty) {
      return Utils.showSnackBar('erreur');
    }
    return usersData;
  }

  Future updateUsername({required String id, required String username}) async {
    try {
      usersCollection.doc(id).update({
        "username": username,
      }).whenComplete(() {
        readUser(auth.currentUser!.uid);
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
        readUser(auth.currentUser!.uid);
        Get.snackbar(
            "Modification réussie", "Votre email a bien été modifiée !",
            snackPosition: SnackPosition.BOTTOM);
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  Future updateBirthday(
      {required String id, required DateTime birthday}
  ) async {
    try {
      await usersCollection.doc(id).update({
        "birthday": birthday,
      }).whenComplete(() {
        readUser(auth.currentUser!.uid);
        Get.snackbar("Modification réussie",
            "Votre date de naissance a bien été modifiée !",
            snackPosition: SnackPosition.BOTTOM);
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  Future userDeleteAccount({required String id}) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('user_image');
    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child('${auth.currentUser!.uid}.png');
    // Create a reference to the file to delete
    referenceImageToUpload.delete();
    await usersCollection.doc(id).delete().whenComplete(() {
      auth.currentUser!.delete();
      authController.emailController.clear();
      authController.passwordController.clear();
      Get.toNamed(Routes.AUTH);
      Get.snackbar(
        "Suppression réussie",
        "Votre compte a bien été supprimé. On espère vous revoir bientôt !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[500],
      );
    });
  }
  
  ///================ GET ALL MEMBER EXCEPT ME ==============

  RxList<UserModel> members = RxList<UserModel>([]);

  Stream<List<UserModel>> getAllMembers() => usersCollection
      .where("id", isNotEqualTo: auth.currentUser!.uid)
      .snapshots()
      .map((query) => query.docs.map((item) => UserModel.fromMap(item)).toList());
}