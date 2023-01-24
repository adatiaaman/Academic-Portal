import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentDrop extends StatefulWidget {
  StudentDrop({Key? key}) : super(key: key);

  @override
  State<StudentDrop> createState() => _StudentDropState();
}

final FirebaseFirestore _db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;

Future<List> getApp() async {
  List app = [];
  final document = await _db.collection('Student').doc(user.email!).get();
  final stu = document.data()!['one'];
  // return app;
  for (var v in stu) {
    final vv = v as Map<String, dynamic>;
    final vm =
        vv.map((key, value) => MapEntry(key.toString(), value.toString()));

    app.add(vm.entries.first);
  }
  return app;
}

class _StudentDropState extends State<StudentDrop> {
  List<dynamic> req = [];

  @override
  void initState() {
    super.initState();
    getApp().then((List val) {
      setState(() {
        req = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drop Course'),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: req.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Container(
                    height: 50,
                    margin: const EdgeInsets.all(2),
                    child: Center(
                      child: Text(
                        '${req[index].key} : ${req[index].value}', // '${req[index]}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      List<MapEntry<String, dynamic>> temp = [];
                      // Utils.showSnackBar(emails.length.toString());
                      for (int i = 0; i < req.length; i = i + 1) {
                        if (i == index) continue;
                        temp.add(MapEntry(req[i].key, req[i].value));
                      }
                      List<Map<String, dynamic>> diy = [];
                      for (int i = 0; i < temp.length; i++) {
                        Map<String, dynamic> diy1 = Map();
                        diy1[temp.elementAt(i).key] = temp.elementAt(i).value;
                        diy.add(diy1);
                      }
                      _db
                          .collection('Student')
                          .doc(user.email!)
                          .update({'one': diy});
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => super.widget));
                    },
                    child: Text('Drop'),
                  ),
                ],
              );
            },
          ),
        ),
      ]),
    );
  }
}
