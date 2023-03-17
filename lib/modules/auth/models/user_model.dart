import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';

class UserModel {
  String? id;
  String? email;
  String? username;
  DateTime? birthday;
  String? age;


  // String? url;
  UserModel({
    this.id, 
    this.email, 
    this.username, 
    this.birthday,
    this.age,
    // this.url, 
  }); 

  Map<String, dynamic> toMap()=> {
    "email": email,
    "id": id,
    "username": username,
    "birthday" : Timestamp.fromDate(birthday!),
    "age" : age,
    // "url": url,
  };

  UserModel.fromMap(DocumentSnapshot data) {
    id = data["id"];
    email = data["email"];
    username = data["username"];
    birthday = Utils.toDateTime(data["birthday"]);
    age = data["age"];
    // url = data["url"];
  }

  Map<String, dynamic>toJson() => {
    'id': id,
    'email' : email,
    'username' : username,
    "birthday" : Timestamp.fromDate(birthday!),
    "age" : age,
    // 'url': url,
  };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    username: json['username'],
    birthday: Utils.toDateTime(json["birthday"]),
    // url: json['url'],
  );
}
