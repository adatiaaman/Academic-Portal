import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dep_2/utility/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const List<String> list = <String>['Student', 'Instructor', 'Advisor'];

class SignUp extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUp({super.key, required this.onClickedSignIn});

  @override
  State<SignUp> createState() => _SignUpState();
}

bool checkrpr(String email) {
  RegExp regex = RegExp(r"[a-zA-Z0-9]+@iitrpr\.ac\.in");
  return regex.hasMatch(email);
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String userType = 'Student';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) => email != null &&
                          !EmailValidator.validate(email) &&
                          checkrpr(email) == true
                      ? 'Enter a valid email'
                      : null,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: passwordController,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                      labelText: 'Password'), // , icon: Icons.remove_red_eye
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) => val != null && val.length < 8
                      ? 'Enter min. 8 characters'
                      : null,
                ),
                const SizedBox(
                  height: 12,
                ),
                DropdownButton<String>(
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: userType,
                    onChanged: (String? value) {
                      setState(() {
                        userType = value!;
                      });
                    }),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                  icon: const Icon(
                    Icons.lock_open,
                    size: 32,
                  ),
                  label: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: signUp,
                ),
                const SizedBox(
                  height: 24,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account?  ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Log In',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => Center(
    //     child: CircularProgressIndicator(),
    //   ),
    // );
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      _firestore.collection('User').doc(emailController.text.trim()).set({
        'Email': emailController.text.trim(),
        'Password': passwordController.text.trim(),
        'Type': userType
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    // navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
