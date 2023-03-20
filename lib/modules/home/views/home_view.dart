import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/modules/auth/controllers/auth_controller.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/modules/profile/controllers/profile_controller.dart';
import 'package:newappfirebase/modules/profile/views/profile_view.dart';

import '../../../routes/app_pages.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

  AuthController authController = AuthController();
  ProfileController profileController = ProfileController();

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("New firebase"),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                value: 'profil',
                child: Row(
                  children: const <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Profil'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: const <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Déconnexion'),
                  ],
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'profil') {
                Get.toNamed(Routes.PROFILEVIEW);

              }
              else if (itemIdentifier == 'logout') {
                authController.signOut();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<UserModel?>(
          future: profileController.readUser(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            return snapshot.hasData ?
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Get.toNamed(Routes.CHATVIEW);
                  //     },
                  //     child: Card(
                  //       elevation: 10,
                  //       shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8)),
                  //       child: Center(
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: <Widget>[
                  //             Image.asset("assets/images/Chat.png"),
                  //             ListTile(
                  //               title: Text("Mon t'chat!"),
                  //               subtitle: Text("Un t'chat firebase..."),
                  //               leading: Icon(Icons.chat_bubble),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.LISTUSERSVIEW);
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset("assets/images/Chat.png"),
                              ListTile(
                                title: Text("Membres"),
                                subtitle: Text("Liste des utilisateurs "),
                                leading: Icon(Icons.person),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ):
            const Center(
              child: CircularProgressIndicator(),
            );
          }
        ),
      ),
    );
  }
}