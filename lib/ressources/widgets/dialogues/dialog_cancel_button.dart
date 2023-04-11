import 'package:flutter/material.dart';

class DialogCancelButton extends StatelessWidget {
  const DialogCancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(Colors.red)),
      child: const Text(
        "Annuler",
        style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
      ),
    );
  }
}