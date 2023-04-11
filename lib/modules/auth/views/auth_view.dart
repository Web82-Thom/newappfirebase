import 'package:flutter/material.dart';
import 'package:newappfirebase/modules/auth/controllers/auth_controller.dart';
import 'package:newappfirebase/modules/auth/views/email_verification_view.dart';
import 'package:newappfirebase/modules/auth/widgets/signin_widget.dart';
import 'package:newappfirebase/modules/auth/widgets/signup_widget.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

AuthController authController = AuthController();

class _AuthViewState extends State<AuthView> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return isLogin 
    ? SigninWidget(onClickedSignUp: toggle,)
    : SignupWidget(onClickedSignIn: toggle,);
  }
  
  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }
}