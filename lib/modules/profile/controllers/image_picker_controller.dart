import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:newappfirebase/modules/auth/controllers/auth_controller.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';
import 'package:uuid/uuid.dart';

class ImagePickerController extends ChangeNotifier {
  RxString imagePath = "".obs;
  RxString imageSize = "".obs;

  AuthController authController = Get.put(AuthController());
  FirebaseAuth auth = FirebaseAuth.instance;

  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  Reference referenceRoot = FirebaseStorage.instance.ref();
  RxBool isPictureSent = false.obs;

  void pickerImage(ImageSource imageSource) async {

    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
      imageSize.value = "${((File(imagePath.value)).lengthSync()/1024/1024).toStringAsFixed(2)}Mb";
    } else {
      Get.snackbar("Error", "You have selected no Image",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.purple,
          colorText: Colors.white);
    }
  }

  Future<void> updateUrlUser(ImageSource imageSource)async {
    /*
    * Step 1. Pick/Capture an image   (image_picker)
    * Step 2. Upload the image to Firebase storage
    * Step 3. Get the URL of the uploaded image
    * Step 4. Store the image URL inside the corresponding
    *         document of the database.
    * Step 5. Display the image on the list
    */

    /*Step 1:Pick image*/
    //Install image_picker
    //Import the corresponding library

    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: imageSource);
    print('${file?.path}');

    if (file == null) return;
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('user_image');
    Reference referenceImageToUpload = referenceDirImages.child('${auth.currentUser!.uid}.png');

    try {
      await referenceImageToUpload.putFile(File(file.path));
      final imageURL = await referenceImageToUpload.getDownloadURL();
      FirebaseFirestore.instance.collection("users")
        .doc(auth.currentUser!.uid)
        .update({'url': imageURL},);
    }  catch (error) {
      Utils.showSnackBar(error.toString());
    }
  }

  Future<String> downloadURL(String imageName) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('user_image');
    Reference referenceImageToUpload = referenceDirImages.child("${auth.currentUser!.uid}.png");
    String downloadURL = await referenceImageToUpload.getDownloadURL();
    return downloadURL;
  }

  ageCalculator(DateTime date){
    DateTime birthday = date;
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthday.year;
    int month1 = currentDate.month;
    int month2 = birthday.month;

    if(month2 > month1){
      age--;
    } else if (month1 == month2){
      int day1 = currentDate.day;
      int day2 = birthday.day;
      if(day2 > day1) {
        age--;
      }
    }
    return age;
  }
}