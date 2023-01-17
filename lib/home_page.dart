import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _user;
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
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                onPressed: signOut),
          ],
        ),
      ),
    );
  }

  void signOut() async {
    FirebaseAuth.instance.signOut();
  }
}
