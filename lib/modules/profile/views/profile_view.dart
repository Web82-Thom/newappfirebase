import 'dart:io';

import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/modules/profile/controllers/profile_controller.dart';
import 'package:newappfirebase/modules/profile/widgets/custom_text_field.dart';
import 'package:newappfirebase/ressources/widgets/dialogues/dialog_confirm_button.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';
import 'package:newappfirebase/routes/app_pages.dart';

import '../../../ressources/widgets/dialogues/dialog_cancel_button.dart';
import '../../auth/controllers/auth_controller.dart';


class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

AuthController authController = AuthController();
ProfileController profilController = ProfileController();

Color _color1 = Colors.white;
Color _color2 = Color(0xff777777);
Color _color3 = Color(0xFF515151);
FirebaseAuth auth = FirebaseAuth.instance;
// ProfileController profileController = ProfileController();
TextEditingController _usernameField = TextEditingController();
TextEditingController _emailField = TextEditingController();
TextEditingController _ageField = TextEditingController();

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    
    final ref = FirebaseDatabase.instance.ref('users');
    final Size size = MediaQuery.of(context).size;
    final double profilePictureSize = MediaQuery.of(context).size.width / 3;

    return FutureBuilder<UserModel?>(
      future: profilController.readUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Mon profil"),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Get.toNamed(Routes.HOME);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: snapshot.hasData ? 
              Column(
                children: [
                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40.0,
                        ),
                        const Text(
                          "Nom d'utilisateur",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///==========USERNAME DISPLAY==========///
                            Expanded(
                              child: user!.username == ''
                              ? const Text(
                                "Modifier mon nom d'utilsateur",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                user.username.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ///==========USERNAME EDIT==========///
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                  title: "Modifier le nom d'utilisateur",
                                  content: CustomTextField(
                                      controller: _usernameField,
                                      labelText: "Nom d'utilisateur",
                                      isObscure: false),
                                  cancel: const DialogCancelButton(),
                                  confirm: DialogConfirmButton(
                                    onPressed: () {
                                      // profileController.updateUsername(
                                      //     id: user.id.toString(),
                                      //     username: _usernameField.text);
                                      // _usernameField.clear();
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        ///==========AGE DISPLAY==========///
                        const Text(
                          'Age',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                user.age.toString(),
                                style: const TextStyle(
                                  fontSize: 16, color: Colors.white,
                                ),
                              ),
                            ),
                            ///=============AGE EDIT=============///
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                  title: "Modifier mon age",
                                  content: CustomTextField(
                                    controller: _ageField,
                                    labelText: "Age",
                                    isObscure: false,
                                  ),
                                  cancel: const DialogCancelButton(),
                                  confirm: DialogConfirmButton(
                                    onPressed: () {
                                      // profileController.updateEmail(
                                      //     id: user.id.toString(),
                                      //     email: _emailField.text);
                                      // _emailField.clear();
                                      // Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        ///=============BIRTHDAY DISPLAY=============///
                        const Text(
                          "Date d'anniverssaire",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                DateFormat('yMMMMEEEEd', 'fr_FR')
                                .format(user.birthday!)
                                .toString(),
                                style: const TextStyle(
                                  fontSize: 16, 
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ///=============BIRTHDAY EDIT=============///
                            GestureDetector(
                              onTap: () {
                                DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1900, 1, 1),
                                maxTime: DateTime(2100, 12, 31), 
                                onChanged: (date) {
                                  print('change $date');
                                }, 
                                onConfirm: (date) {
                                  print('confirm $date');
                                }, 
                                currentTime: DateTime.now(), 
                                locale: LocaleType.fr).then((date){
                                  setState(() {
                                    authController.selectedDate = date;
                                  });
                                  print(authController.selectedDate);
                                });
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        ///=============EMAIL DISPLAY=============///
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                user.email.toString(),
                                style: const TextStyle(
                                  fontSize: 16, 
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ///=============EMAIL EDIT=============///
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                  title: "Modifier l'email",
                                  content: CustomTextField(
                                    controller: _emailField,
                                    labelText: "Email",
                                    isObscure: false,
                                  ),
                                  cancel: const DialogCancelButton(),
                                  confirm: DialogConfirmButton(
                                    onPressed: () {
                                      // profileController.updateEmail(
                                      //     id: user.id.toString(),
                                      //     email: _emailField.text);
                                      // _emailField.clear();
                                      // Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ///=============BUTTON DELETE USER=============///
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "ATTENTION !",
                                  middleText:
                                      "Toute suppression de compte est définitive. Souhaitez-vous supprimer votre compte ?",
                                  cancel: const DialogCancelButton(),
                                  confirm: DialogConfirmButton(
                                    onPressed: () =>
                                    print("delete"),
                                        // authController.deleteUser(),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                              ),
                              child: const Text(
                                "Supprimer le compte",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ) :
                   
                     Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 100,
                            width : 100,
                            child: CircularProgressIndicator(strokeWidth: 5,)),
                          SizedBox(height: 100.00,),
                          Text('Chargement des données...', style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                );
                  
                }
        );
      }
  }
