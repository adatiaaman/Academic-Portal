import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_2/screens/student_drop_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

final FirebaseFirestore _db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;

Future<List> getApp() async {
  List app = [];
  final document = await _db.collection('Student').doc(user.email!).get();
  app = document.data()!['one'];
  // List app = [];
  // for (var val in requests) {
  //   if (val['Name'] == user.email!) {
  //     app.add(val);
  //   }
  // }
  return app;
}

// Future<List> getReq() async {
//   List requests = [];
//   final document = await _db.collection('Student').doc('0').get();
//   requests = document.data()!['request'];
//   return requests;
// }

Future<List> getStu() async {
  List stu = [];
  final document = await _db.collection('Student').doc(user.email!).get();
  stu = document.data()!['one'];
  return stu;
}

List<String> inst = [];

Future<List> getCourse() async {
  List course = [];

  final document = await _db.collection('Course').get().then((value) {
    value.docs.forEach((element) {
      final cc = element.data()['details'];
      for (var c in cc) {
        inst.add(element.id);
        course.add(c);
      }
      // course.add(element.data());
    });
  });
  // final prof = document.docs.single;
  // course = document.data()!['details'];
  return course;
}

class _StudentPageState extends State<StudentPage> {
  List<dynamic> app = [];
  // List<dynamic> req = [];
  List<dynamic> stud = [];
  List<dynamic> course = [];

  @override
  void initState() {
    super.initState();
    getApp().then((List val) {
      setState(() {
        app = val;
      });
    });
    // getReq().then((List val) {
    //   setState(() {
    //     req = val;
    //   });
    // });
    getStu().then((List val) {
      setState(() {
        stud = val;
      });
    });
    getCourse().then((List val) {
      setState(() {
        course = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Enrollment'),
      ),
      body: Column(children: [
        const Text(
          'Available Courses: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: course.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Container(
                    height: 50,
                    margin: const EdgeInsets.all(2),
                    child: Center(
                      child: Text(
                        '${course[index].toString()} (${inst[index]})', // '${req[index]}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // stud.add({'${course[index].toString()}': '0'});
                      stud.add({'${course[index]}': 'Requested'});
                      _db
                          .collection('Student')
                          .doc(user.email!)
                          .set({'one': stud});
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => super.widget));
                    },
                    child: Text('Enroll'),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        Container(
          height: 40,
          width: 250,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentDrop(),
                ),
              );
            },
            child: const Text(
              'Drop Courses',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        Text(
          'Status: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: app.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                margin: const EdgeInsets.all(2),
                child: Center(
                    child: Text(
                  '${app[index]}', // (${instructor[index]})
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
