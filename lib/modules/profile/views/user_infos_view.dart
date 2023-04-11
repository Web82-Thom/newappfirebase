import 'package:flutter/material.dart';

class UserInfosView extends StatefulWidget {
  const UserInfosView({super.key});

  @override
  State<UserInfosView> createState() => _UserInfosViewState();
}

class _UserInfosViewState extends State<UserInfosView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails du membre"),),
      body: Container(color: Colors.amber,),
    );
  }
}