import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newappfirebase/ressources/widgets/utils.dart';

class UserModel {
  String? id;
  String? email;
  String? username;
  DateTime? birthday;
  String? age;
  String? userToken;
  // Timestamp? createdAt;
  // String? url;

  UserModel({
    this.id, 
    this.email, 
    this.username, 
    this.birthday,
    this.age,
    this.userToken,
    // this.url, 
  }); 

  Map<String, dynamic> toMap()=> {
    "email": email,
    "id": id,
    "username": username,
    "birthday" : Timestamp.fromDate(birthday!),
    "age" : age,
    "userToken" : userToken,
    // "url": url,
  };

  UserModel.fromMap(DocumentSnapshot data) {
    id = data["id"];
    email = data["email"];
    username = data["username"];
    birthday = Utils.toDateTime(data["birthday"]);
    age = data["age"];
    userToken = data["userToken"];
    // url = data["url"];
  }

  Map<String, dynamic>toJson() => {
    'id': id,
    'email' : email,
    'username' : username,
    "birthday" : Timestamp.fromDate(birthday!),
    "age" : age,
    "userToken" : userToken,
    // 'url': url,
  };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    username: json['username'],
    birthday: Utils.toDateTime(json["birthday"]),
    age: json['age'],
    userToken: json['userToken'],
    // url: json['url'],
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
      );
  }


Map<String, dynamic>toFirestore() => {
    'id': id??"invited",
    'email' : email??"invited",
    'username' : username??"invited",
    "birthday" : Timestamp.fromDate(birthday!),//??Timestamp.now(),
    "age" : age??"00",
    "userToken" : userToken??"invited",
    // 'url': url,
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
    );
  }
  
  
}
