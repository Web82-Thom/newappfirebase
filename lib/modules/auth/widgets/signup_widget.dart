import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newappfirebase/main.dart';
import 'package:newappfirebase/modules/auth/controllers/auth_controller.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';
import 'package:newappfirebase/routes/app_pages.dart';

class SignupWidget extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignupWidget({super.key, required this.onClickedSignIn});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
} 

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

class _SignupWidgetState extends State<SignupWidget> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40,),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.black87,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: "Entrez votre Email"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) { return
                email != null && !EmailValidator.validate(email)
                ? "Entrer un email valide"
                : null;
              },
            ),
            const SizedBox(height: 4,),
            TextFormField(
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) { return
                value != null && value.length < 6
                ? "Entrer un mot de passe de 6 caractère minimum"
                : null;
              },
            ),
            const SizedBox(height: 20.00,),
            ElevatedButton.icon(
              onPressed: (){
                signup();
              }, 
              icon: const Icon(Icons.lock_open, size: 32.00), 
              label: const Text("S'inscrire", style: TextStyle(fontSize: 24.00),),
            ),
            const SizedBox(height: 25.00,),
            RichText(
              text: TextSpan(
                text: 'Vous avez un compte ?',
                style: const TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                    ..onTap = widget.onClickedSignIn,
                    text: " Connexion",
                    style: const TextStyle(
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
    );
  }
  
  Future signup() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e){
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