import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/modules/home/views/home_view.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {

  bool isEmailVerified = false;
  bool cancelResendEmail= false;
  Timer? timer;

  @override
  void initState() {
    
    super.initState();

    //user needs to be create before!
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
    ? const HomeView()
    : Scaffold(
        appBar: AppBar(
          title: const Text("Vérification du mail"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Veuillez verifier votre boite email et cliqué sur le lien pour valider votre accès à l'application"),
            const SizedBox(height: 24.0),
            ElevatedButton.icon(
              onPressed: (){
                cancelResendEmail ? sendVerificationEmail(): null;
              }, 
              icon: const Icon(Icons.email), 
              label: const Text("Renvoyer un Email"),
            ),
            const SizedBox(height: 8,),
            TextButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
              }, 
              child: const Text("Annuler"),
            ),
          ],
        ),
      );
  Future sendVerificationEmail() async {
   
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification().whenComplete(()async{
        setState(() {
          cancelResendEmail = false;
        });
        await Future.delayed(const Duration(seconds: 5));
        setState(() {
          cancelResendEmail = true;
        });
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState((){
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified) timer?.cancel();
}
}



