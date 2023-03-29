import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {
 
  static toastMessage(String message){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? message) {
    if(message == null) return;
    final snackBar = SnackBar(content: Text(message), backgroundColor: Colors.red,);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static DateTime? toDateTime(Timestamp value) {
    // ignore: unnecessary_null_comparison
    if (value == null) return null;

    return value.toDate();
  }
}