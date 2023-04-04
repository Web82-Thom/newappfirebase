import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';

class UserModel {
  String? id;
  String? email;
  String? username;
  DateTime? birthday;
  String? age;
  String? userToken;
  String? url;
  Timestamp? createdAt;


  UserModel({
    this.id, 
    this.email, 
    this.username, 
    this.birthday,
    this.age,
    this.userToken,
    this.url, 
    this.createdAt,
  }); 

  Map<String, dynamic> toMap()=> {
    "email": email,
    "id": id,
    "username": username,
    "birthday" : Timestamp.fromDate(birthday!),
    "age" : age,
    "userToken" : userToken,
    "url": url ??  "user_image/profile.png",
    "createdAt" : createdAt
  };

  UserModel.fromMap(DocumentSnapshot data) {
    id = data["id"];
    email = data["email"];
    username = data["username"];
    birthday = Utils.toDateTime(data["birthday"]);
    age = data["age"];
    userToken = data["userToken"];
    url = data["url"];
    createdAt = data["createdAt"];
  }

  Map<String, dynamic>toJson() => {
    'id': id,
    'email' : email,
    'username' : username,
    "birthday" : Timestamp.fromDate(birthday!),
    "age" : age,
    "userToken" : userToken,
        "url": url ??  Image.asset("assets/images/profile.png"),

    'createdAt': createdAt,
  };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    username: json['username'],
    birthday: Utils.toDateTime(json["birthday"]),
    age: json['age'],
    userToken: json['userToken'],
    url: json['url'],
    createdAt: json['createdAt'],
  );

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document ) {
    final data = document.data();
    return UserModel(
      id: document.id, 
      email: data!["email"], 
      username: data["username"],
      birthday: Utils.toDateTime(data["birthday"]),
      age: data["age"],
      userToken: data["userToken"],
      url: data["url"],
      createdAt: data["createdAt"],
    );
  }


Map<String, dynamic>toFirestore() => {
    'id': id??"invited",
    'email' : email??"invited",
    'username' : username??"invited",
    "birthday" : Timestamp.fromDate(birthday!),//??Timestamp.now(),
    "age" : age??"00",
    "userToken" : userToken??"invited",
    "url": url ??  Image.asset("assets/images/profile.png"),
    "createdAt": createdAt,
  };
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      id: data?["id"], 
      email: data?["email"], 
      username: data?["username"],
      birthday: Utils.toDateTime(data?["birthday"]),
      age: data?["age"],
      userToken: data?["userToken"],
      url: data?["url"] ?? Image.asset("assets/images/profile.png"),
      createdAt: data?["createdAt"],
    );
  }
  
  
}
