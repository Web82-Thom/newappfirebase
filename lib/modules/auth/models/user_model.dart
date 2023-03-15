import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? email;
  String? username;
  String? url;
  UserModel({this.id, this.email, this.username, this.url, }); 

  Map<String, dynamic> toMap()=> {
    "email": email,
    "id": id,
    "username": username,
    "url": url,
  };

  UserModel.fromMap(DocumentSnapshot data) {
    id = data["id"];
    email = data["email"];
    username = data["username"];
    url = data["url"];
  }

  Map<String, dynamic>toJson() => {
    'id': id,
    'email' : email,
    'username' : username,
    'url': url,
  };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    username: json['username'],
    url: json['url'],
  );
}
