import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newappfirebase/modules/auth/controllers/auth_controller.dart';
import 'package:newappfirebase/modules/auth/widgets/signup_widget.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  @override
  void dispose(){
    authController.emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mot de passe oublier"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Form(
            key: authController.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Entrez votre Email et verifier votre boite pour changer le mot de passe"),
                const SizedBox(height: 25.0,),
                TextFormField(
                  controller: authController.emailController,
                  cursorColor: Colors.black87,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "Entrez votre Email"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) { 
                    return email != null && !EmailValidator.validate(email)
                    ? "Entrer un email valide"
                    : null;
                  },
                ),
                const SizedBox(height: 25.0,),
                ElevatedButton.icon(
                  onPressed: (){
                    authController.resetPassword(context);
                  }, 
                  icon: const Icon(Icons.email_outlined), 
                  label: const Text("Envoyer"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

