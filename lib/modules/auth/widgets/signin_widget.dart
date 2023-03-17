import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/main.dart';
import 'package:newappfirebase/modules/auth/controllers/auth_controller.dart';
import 'package:newappfirebase/modules/auth/views/auth_view.dart';
import 'package:newappfirebase/modules/auth/views/forgot_password_view.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';
import 'package:newappfirebase/routes/app_pages.dart';

class SigninWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  
  SigninWidget({
    super.key,
    required this.onClickedSignUp
  });

  @override
  State<SigninWidget> createState() => _SigninWidgetState();
}
  AuthController authController = AuthController();
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

class _SigninWidgetState extends State<SigninWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Connexion",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 40,),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: authController.emailController,
                    cursorColor: Colors.black87,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: "Entrez votre Email",
                    ),
                  ),
                  const SizedBox(height: 8.0,),
                  TextField(
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
                  ),
                  const SizedBox(height: 20.00,),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(right: 30, left: 30, top: 10, bottom: 10),
                    ),
                    onPressed: (){
                      authController.signin(context);
                    }, 
                    icon: const Icon(Icons.lock_open, size: 25.00), 
                    label: const Text("Se connecter", style: TextStyle(fontSize: 20.00),),
                  ),
                  const SizedBox(height: 25.00,),
                  GestureDetector(
                    child: const Text(
                      "Mot de passe oublier ?",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.amber,
                        fontSize: 15,
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordView(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10.0,),
                  RichText(
                    text: TextSpan(
                      text: 'Pas encore de compte ? ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                          text: " Inscription",
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.amber,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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


