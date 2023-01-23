import 'package:dep_2/authentification/auth_page.dart';
import 'package:dep_2/authentification/log_in.dart';
import 'package:dep_2/screens/start_up.dart';
import 'package:dep_2/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dep_2/screens/home_page.dart';
import 'dart:html';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyAqHsUicdbUaas7RhLac8I7EhN4RiEnlu4',
            appId: '1:952843904069:web:9dd6a0486d9ef1b5802f2c',
            messagingSenderId: '952843904069',
            projectId: 'dep-2-1f180'));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}
