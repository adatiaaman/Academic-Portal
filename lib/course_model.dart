import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String? id;
  final String instructor;
  final String name;

  const CourseModel({
    this.id,
    required this.instructor,
    required this.name,
  });

  toJson() {
    return {
      "Instructor": instructor,
      "Name": name,
    };
  }

  factory CourseModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return CourseModel(
        id: document.id, instructor: data!["Instructor"], name: data["Name"]);
  }
}
