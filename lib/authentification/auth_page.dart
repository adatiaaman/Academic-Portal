import 'package:dep_2/authentification/log_in.dart';
import 'package:dep_2/authentification/sign_up.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? Login(
          onClickedSignUp: toggle,
        )
      : SignUp(
          onClickedSignIn: toggle,
        );

  void toggle() => setState(() => isLogin = !isLogin);
}
