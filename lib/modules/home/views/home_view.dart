import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}
final user = FirebaseAuth.instance.currentUser!;

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
                // authController.userSignOut();
              }
              else if (itemIdentifier == 'logout') {
                // FirebaseAuth.instance.signOut();
                signOut();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          user.email!,
          style: const TextStyle(
            color: Colors.white
          ),  
        )),
    );
  }
 Future signOut() async  {
     await FirebaseAuth.instance.signOut().whenComplete(() {
      Get.toNamed(Routes.AUTH);
      Get.snackbar("Déconnexion réussie", "",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[500],
      );
    });
  }

}