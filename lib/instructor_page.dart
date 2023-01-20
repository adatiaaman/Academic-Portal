import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_2/course_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class InstructorPage extends StatefulWidget {
  const InstructorPage({super.key});

  @override
  State<InstructorPage> createState() => _InstructorPageState();
}

final FirebaseFirestore _db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;

Future<List> getCourse(String email) async {
  List instruct = [];
  final document = await _db.collection('Course').doc(user.email!).get();
  instruct = document.data()!['details'];
  return instruct;
}

class _InstructorPageState extends State<InstructorPage> {
  List<dynamic> course = [];

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCourse(user.email!).then((List val) {
      setState(() {
        course = val;
      });
    });
  }

  void addItemToList() {
    setState(() {
      course.insert(0, nameController.text);
      // instructor.insert(0, user.email!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructor'),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Course Name',
            ),
          ),
        ),
        ElevatedButton(
          child: const Text('Add'),
          onPressed: () {
            addItemToList();
            _db.collection('Course').doc(user.email!).set({'details': course});
          },
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: course.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                margin: const EdgeInsets.all(2),
                child: Center(
                    child: Text(
                  '${course[index]}', // (${instructor[index]})
                  style: TextStyle(fontSize: 18),
                )),
              );
            },
          ),
        ),
      ]),
    );
  }
}
