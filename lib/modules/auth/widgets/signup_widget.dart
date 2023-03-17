import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:newappfirebase/main.dart';
import 'package:newappfirebase/modules/auth/views/auth_view.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';
import 'package:intl/intl.dart';

class SignupWidget extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignupWidget({super.key, required this.onClickedSignIn});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
} 

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final birthdayController = TextEditingController();
  final ageController = TextEditingController();
  
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;
  
  @override
  void close(){
    emailController.clear();
    passwordController.clear();
    close();
  }

class _SignupWidgetState extends State<SignupWidget> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 50, bottom: 10),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Inscription",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 40,),
                  TextFormField(
                    style: TextStyle(color: Colors.white,),
                    controller: userNameController,
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
                  TextFormField(
                    style: TextStyle(color: Colors.white, fontWeight: null),
                    keyboardType: TextInputType.number,
                    controller: ageController,
                    cursorColor: Colors.black87,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: "Entrez votre age", focusColor: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (age) { return
                      age != null && age.length > 2
                      ? "Trop vieux !"
                      : null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox( height: 20, 
                        child: Text(
                          selectedDate == null 
                          ? "Sélectionner une date" 
                          : DateFormat('yMMMMEEEEd', 'fr_FR').format(selectedDate!).toString(),
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(onPressed: (){
                        DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1900, 1, 1),
                          maxTime: DateTime(2100, 12, 31), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                          }, currentTime: DateTime.now(), locale: LocaleType.fr).then((date){
                            setState(() {
                              selectedDate = date;
                            });
                            print(selectedDate);
                          },
                        );
                      }, child: const Text("Date de naissance")),
                    ],
                  ),
                  const SizedBox(height: 4,),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: emailController,
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
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: passwordController,
                    cursorColor: Colors.black87,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 15),
                  
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
                    icon: const Icon(Icons.lock_open, size: 25.00), 
                    style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(right: 30, left: 30, top: 10, bottom: 10),
                  ),
                    label: const Text("S'inscrire", style: TextStyle(fontSize: 20.00),),
                  ),
                  const SizedBox(height: 25.00,),
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
        email: emailController.text, password: passwordController.text)
        .whenComplete(() {
          authController.userCreateProfile(
            username: userNameController.text, 
            email: emailController.text,
            birthday: DateTime.parse(selectedDate.toString()),
            age: ageController.text,
            // userurl: authController.userImageFile!,
          );
        });
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