import 'package:dep_2/authentification/auth_page.dart';
import 'package:dep_2/screens/home_page.dart';
import 'package:dep_2/authentification/log_in.dart';
import 'package:dep_2/authentification/sign_up.dart';
import 'package:dep_2/authentification/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Get Started')),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                    '\n\nDEP Team: T11\nAman Pankaj Adatia - 2020CSB1154\nSanyam Walia - 2020CSB1122\nAnubhav Kataria - 2020CSB1073\nDileep Kumar Kanwat - 2020CSB1085\n\n'),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 60.0,
                ),
                child: Center(
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return VerifyEmail();
                                } else {
                                  return AuthPage();
                                }
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }
}
