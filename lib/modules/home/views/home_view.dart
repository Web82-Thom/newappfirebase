import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/modules/auth/controllers/auth_controller.dart';
import 'package:newappfirebase/modules/auth/models/user_model.dart';
import 'package:newappfirebase/modules/profile/controllers/contact_controller.dart';
import 'package:newappfirebase/modules/profile/controllers/profile_controller.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';

import '../../../routes/app_pages.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

  AuthController authController = AuthController();
  ContactController contactController = ContactController();
  ProfileController profileController = ProfileController();
  FirebaseAuth auth = FirebaseAuth.instance;

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text("Web82-Thom", style: TextStyle(fontSize: 18),),
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
                  // authController.signOut();
                  Get.toNamed(Routes.AUTH);
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<UserModel?>(
            future: profileController.readUser(auth.currentUser!.uid),
            builder: (context, snapshot) {
              final user = snapshot.data;
              return user != null ?
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      // height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:   [
                            const Center(child: Text(" Bienvenue sur mon App", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),)),
                            const SizedBox(height: 10,),
                            const Text("C'est application à pour but de montrer mon savoir faire en tant que développeur App Flutter.", style: TextStyle(color: Colors.white, fontSize: 16),),
                            const SizedBox(height: 10,),
                            const Text("Détails des fonctionnalitées et services : ", style: TextStyle(color: Colors.white, fontSize: 16),),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("\u2022 Inscriptions vias le serveur Firebase, avec verification par email", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  Text("\u2022 Work with GitHub Web82-Thom ", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  Text("\u2022 Création d'un tchat pour tous,", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  Text("\u2022 Création d'un tchat privatif,", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  Text("\u2022 Rechercher un membre et commencer une conversation", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  Text("\u2022 Gestion des images avec Firebase", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  SizedBox(height: 5,),
                                  Text("CRUD Firebase, Firestore", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("\u2022 Créer un utilisateur", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(left: 8.0),
                                    child: Text("\u2022 Lire les données utilisateur", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("\u2022 Modifier son profil", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("\u2022 Supprimer son compte", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: GestureDetector(
                            onTap: () { 
                              Get.toNamed(Routes.CHATVIEW); 
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
                                    const ListTile(
                                      title: Text("Mon t'chat!"),
                                      subtitle: Text("Un t'chat pour tous"),
                                      leading: Icon(Icons.chat_bubble),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: GestureDetector(
                            onTap: () {
                              contactController.asyncLoadData();
                              Get.toNamed(Routes.CHATROOM);
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset("assets/images/peoples-icon.png"),
                                    const ListTile(
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
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: GestureDetector(
                            onTap: () {
                              // Get.toNamed(Routes.CHATVIEW);
                              Utils.showSnackBar("Gérer mes amis");
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset("assets/images/friends.png"),
                                    const ListTile(
                                      title: Text("Mes amis"),
                                      subtitle: Text("Gérer vos amis"),
                                      leading: Icon(Icons.chat_bubble),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: GestureDetector(
                            onTap: () {
                              // Get.toNamed(Routes.CHATVIEW);
                              Utils.showSnackBar("Gérer les activités");
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset("assets/images/activity.png"),
                                    const ListTile(
                                      title: Text("Activités"),
                                      subtitle: Text("Evenements"),
                                      leading: Icon(Icons.chat_bubble),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                  ],
                ):
              const Center(
                child: CircularProgressIndicator(),
              );
            }
          ),
        ),
      ),
    );
  }
}