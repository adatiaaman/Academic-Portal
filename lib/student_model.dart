import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String? id;
  final String bit;
  final String course;
  final String name;

  const StudentModel({
    this.id,
    required this.bit,
    required this.course,
    required this.name,
  });

  toJson() {
    return {
      "Bit": bit,
      "Course": course,
      "Name": name,
    };
  }

  factory StudentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return StudentModel(
        id: document.id,
        bit: data!["Bit"],
        course: data["Course"],
        name: data['Name']);
  }
}
