import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_2/models/student_model.dart';
import 'package:dep_2/models/user_model.dart';
import 'package:dep_2/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuple/tuple.dart';

class AdvisorPage extends StatefulWidget {
  const AdvisorPage({super.key});

  @override
  State<AdvisorPage> createState() => _AdvisorPageState();
}

final FirebaseFirestore _db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;

Future<List> getReq() async {
  List req = [];
  final doc =
      await _db.collection('User').where('Type', isEqualTo: 'Student').get();

  final stu = doc.docs.map((e) => UserModel.fromSnapshot(e)).toList();
  for (var c in stu) {
    final docu = await _db.collection('Student').doc(c.email).get();
    final val = docu.data()!['one'];
    for (var v in val) {
      // MapEntry entry =
      //     v.keys.firstWhere((element) => v[element] == '0', orElse: () => null);

      // if (v != null) {
      //   req.add({entry.key: c.email});
      // }
      final vv = v as Map<String, dynamic>;
      final vm =
          vv.map((key, value) => MapEntry(key.toString(), value.toString()));

      var k = Tuple2(vm.entries.first, c.email);
      // if (k.item1.value == '0')
      req.add(k);
    }
  }

  return req;
}

List<String> emails = [];
List<MapEntry<String, dynamic>> course = [];

class _AdvisorPageState extends State<AdvisorPage> {
  List<dynamic> req = [];

  @override
  void initState() {
    super.initState();
    getReq().then((List val) {
      setState(() {
        req = val;
      });
      for (int e = 0; e < req.length; e = e + 1) {
        emails.add(req[e].item2);
        course.add(MapEntry(req[e].item1.key.toString(), req[e].item1.value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advisor'),
      ),
      body: Column(
        children: [
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
                          '${req[index].item2}: ${req[index].item1.key} : ${req[index].item1.value}', // '${req[index]}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        List<MapEntry<String, dynamic>> temp = [];
                        // Utils.showSnackBar(emails.length.toString());
                        for (int i = 0; i < emails.length; i = i + 1) {
                          if (emails.elementAt(i) == req[index].item2) {
                            if (course.elementAt(i).key ==
                                req[index].item1.key) {
                              // course.elementAt(i).value = "1";
                              temp.add(
                                  MapEntry(req[index].item1.key, "Accepted"));
                            } else {
                              temp.add(course.elementAt(i));
                            }
                          }
                        }
                        List<Map<String, dynamic>> diy = [];
                        for (int i = 0; i < temp.length; i++) {
                          Map<String, dynamic> diy1 = Map();
                          diy1[temp.elementAt(i).key] = temp.elementAt(i).value;
                          diy.add(diy1);
                        }
                        _db
                            .collection('Student')
                            .doc(req[index].item2.toString())
                            .update({
                          'one': diy,
                        });
                      },
                      child: Text('Accept'),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        List<MapEntry<String, dynamic>> temp = [];
                        // Utils.showSnackBar(emails.length.toString());
                        for (int i = 0; i < emails.length; i = i + 1) {
                          if (emails.elementAt(i) == req[index].item2) {
                            if (course.elementAt(i).key ==
                                req[index].item1.key) {
                              // course.elementAt(i).value = "1";
                              temp.add(
                                  MapEntry(req[index].item1.key, "Rejected"));
                            } else {
                              temp.add(course.elementAt(i));
                            }
                          }
                        }
                        List<Map<String, dynamic>> diy = [];
                        for (int i = 0; i < temp.length; i++) {
                          Map<String, dynamic> diy1 = Map();
                          diy1[temp.elementAt(i).key] = temp.elementAt(i).value;
                          diy.add(diy1);
                        }
                        _db
                            .collection('Student')
                            .doc(req[index].item2.toString())
                            .set({
                          'one': diy,
                        });
                      },
                      child: Text('Reject'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
