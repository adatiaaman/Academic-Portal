import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String type;
  final String email;
  final String password;

  const UserModel({
    this.id,
    required this.type,
    required this.email,
    required this.password,
  });

  toJson() {
    return {
      "Type": type,
      "Email": email,
      "Passowrd": password,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return UserModel(
        id: document.id,
        type: data!["Type"],
        email: data["Email"],
        password: data["Password"]);
  }
}
