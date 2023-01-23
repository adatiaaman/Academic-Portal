import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_2/screens/advisor_page.dart';
import 'package:dep_2/screens/instructor_page.dart';
import 'package:dep_2/screens/student_page.dart';
import 'package:dep_2/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;

Future<UserModel> getType(String email) async {
  final document = await _firestore
      .collection('User')
      .where('Email', isEqualTo: email)
      .get();
  final data = document.docs.map((e) => UserModel.fromSnapshot(e)).single;
  return data;
}

class _HomePageState extends State<HomePage> {
  late User _user;
  late String uType;

  @override
  void initState() {
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser!);
  }

  onRefresh(userCred) {
    setState(() {
      _user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                  'DEP Team: T11\nAman Pankaj Adatia - 2020CSB1154\nSanyam Walia - 2020CSB1122\nAnubhav Kataria - 2020CSB1073\nDileep Kumar Kanwat - 2020CSB1085\n\n'),
            ),
            const Text(
              'Logged In as',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              user.email!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: getType(
                user.email!,
              ),
              builder: ((context, snapshot) {
                UserModel uData = snapshot.data as UserModel;
                uType = uData.type;
                return Text(
                  uData.type,
                  style: TextStyle(fontSize: 20),
                );
              }),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                if (uType == 'Student') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentPage()),
                  );
                } else if (uType == 'Instructor') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InstructorPage()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdvisorPage()),
                  );
                }
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(
                Icons.arrow_back,
                size: 32,
              ),
              label: const Text(
                'Log Out',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: signOut,
            ),
          ],
        ),
      ),
    );
  }

  void signOut() async {
    FirebaseAuth.instance.signOut();
  }
}
