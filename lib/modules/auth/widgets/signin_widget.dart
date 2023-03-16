import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/main.dart';
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

class _SigninWidgetState extends State<SigninWidget> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;



  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40,),
          TextField(
            controller: emailController,
            cursorColor: Colors.black87,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: "Entrez votre Email"),
          ),
          const SizedBox(height: 4,),
           TextField(
            controller: passwordController,
            cursorColor: Colors.black87,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
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
            onPressed: (){
              signin();
            }, 
            icon: const Icon(Icons.lock_open, size: 32.00), 
            label: const Text("Se connecter", style: TextStyle(fontSize: 24.00),),
          ),
          const SizedBox(height: 25.00,),
          const SizedBox(height: 16,),
          GestureDetector(
            child: const Text(
              "Mot de passe oublier ?",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.amber,
                fontSize: 20,
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
              text: 'Pas encore de compte ?',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedSignUp,
                  text: " Inscription",
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.amber,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future signin() async{
    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try { 
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
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


