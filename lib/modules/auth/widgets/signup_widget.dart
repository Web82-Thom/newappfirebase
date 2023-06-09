import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newappfirebase/modules/auth/controllers/auth_controller.dart';
import 'package:intl/intl.dart';
import 'package:newappfirebase/modules/profile/controllers/image_picker_controller.dart';
import 'package:newappfirebase/modules/profile/views/profile_view.dart';
import 'package:newappfirebase/modules/profile/widgets/widgets_image_picker/user_image_picker.dart';

class SignupWidget extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignupWidget({super.key, required this.onClickedSignIn});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
} 
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthController authController = AuthController();
  ImagePickerController imagePickerController = ImagePickerController();
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;
  
  XFile? userImageFile;
  
class _SignupWidgetState extends State<SignupWidget> {
 
 void _pickedImage(File image) async {
    setState(() {
      userImageFile = XFile(image.path);
      authController.file = XFile(image.path);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 50, bottom: 10),
              child: Form(
                key: authController.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  //*****TITLE*****//
                    const Text(
                      "Inscription",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 40,),
                  //*****PICKER IMAGE*****//
                  UserImagePicker(_pickedImage),  
                  //*****USERNAME*****//
                    TextFormField(
                      style: const TextStyle(color: Colors.white,),
                      controller: authController.userNameController,
                      cursorColor: Colors.black87,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 15),
                        labelText: "Entrez votre nom d'utilisateur",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (userName) { return
                        userName != null && userName.length < 4
                        ? "Plus de 4 caractères"
                        : null;
                      },
                    ),
                    const SizedBox(height: 4,),
                  //*****BIRTHDAY*****//
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox( height: 20, 
                          child: Text(
                            authController.selectedDate == null 
                            ? "Sélectionner une date" 
                            : DateFormat('yMMMMEEEEd', 'fr_FR').format(authController.selectedDate!).toString(),
                            style: const TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                        ElevatedButton(onPressed: (){
                          DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1900, 1, 1),
                            maxTime: DateTime(2100, 12, 31), 
                            onChanged: (date) {
                              // ignore: avoid_print
                              print('change $date');
                            }, onConfirm: (date) {
                              // ignore: avoid_print
                              print('confirm $date');
                            }, currentTime: DateTime.now(), locale: LocaleType.fr).then((date){
                              setState(() {
                                authController.selectedDate = date;
                              });
                            },
                          );
                        }, child: const Text("Date de naissance")),
                      ],
                    ),
                    const SizedBox(height: 4,),
                  //*****EMAIL*****//
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: authController.emailController,
                      cursorColor: Colors.black87,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 15),
                        labelText: "Entrez votre Email"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) { return
                        email != null && !EmailValidator.validate(email)
                        ? "Entrer un email valide"
                        : null;
                      },
                    ),
                    const SizedBox(height: 4,),
                  //*****PASSWORD*****//
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: authController.passwordController,
                      cursorColor: Colors.black87,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 15),
                        labelText:"Entrez votre mot de passe",
                        suffixIcon: IconButton(
                          icon: Icon(_iconVisible, size: 20, color: Colors.amber,),
                          onPressed: () {
                            _toggleObscureText();
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) { return
                        value != null && value.length < 6
                        ? "Entrer un mot de passe de 6 caractère minimum"
                        : null;
                      },
                    ),
                    const SizedBox(height: 20.00,),
                  //*****BUTTON SIGNUP*****//
                    ElevatedButton.icon(
                      onPressed: (){
                        if (userImageFile != null) {
                          authController.signup(
                            name: authController.userNameController.text,
                            email: authController.emailController.text,
                            birthday: authController.selectedDate!,
                            password: authController.passwordController.text,
                            url: userImageFile!.path,
                          );
                        } else {
                          Get.snackbar(
                            "Attention",
                            "Veuillez prendre une photo !",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.grey[500],
                            duration: Duration(seconds: 3),
                          );
                          return;
                        }
                      }, 
                      icon: const Icon(Icons.lock_open, size: 25.00), 
                      style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(right: 30, left: 30, top: 10, bottom: 10),
                    ),
                      label: const Text("S'inscrire", style: TextStyle(fontSize: 20.00),),
                    ),
                    const SizedBox(height: 25.00,),
                  //*****SWITCH SIGNIN*****//
                    RichText(
                      text: TextSpan(
                        text: 'Vous avez un compte ? ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignIn,
                            text: " Connexion",
                            style: const TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              color: Colors.amber,
                            ) 
                          )
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }
}