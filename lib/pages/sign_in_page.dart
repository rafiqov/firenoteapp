import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenoteapp/commons/loading_widget.dart';
import 'package:firenoteapp/commons/text_with_link.dart';
import 'package:firenoteapp/pages/home_page.dart';
import 'package:firenoteapp/pages/sign_up_page.dart';
import 'package:firenoteapp/services/hive_service.dart';

import 'package:flutter/material.dart';

import '../commons/main_button.dart';
import '../commons/text_field_common_widget.dart';
import '../services/auth_service.dart';

class SignInPage extends StatefulWidget {
  static const String id = 'sign_in_page';

  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void doSignIn() async {
    String email = _emailController.text.trim().toString();
    String password = _passwordController.text.trim().toString();

    if (email.isEmpty || password.isEmpty) {
      showSnackBar(text: 'Wrong something');
      return;
    }

    setState(() => isLoading = true);
    await AuthService.signInUser(email, password)
        .then((user) => _getFireBaseUser(user));
  }

  _getFireBaseUser(User? user) {
    setState(() => isLoading = true);
    if (user != null) {
      HiveDB.storeUser(user);

      _openHome();
    } else {
      showSnackBar(text: AuthService.snackBar!);
    }
  }

  void showSnackBar({required String text}) {
    final snackBar = SnackBar(
      content: Text(text),
    );
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  void _openSignUp() => Navigator.pushReplacementNamed(context, SignUpPage.id);

  void _openHome() => Navigator.pushReplacementNamed(context, HomePage.id);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFieldWidget(name: "email".tr(), controller: _emailController),
                const SizedBox(height: 10),
                TextFieldWidget(
                    name: "password".tr(), controller: _passwordController),
                const SizedBox(height: 10),
                MainButton(function: doSignIn, name: 'sign_in'.tr()),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWithLinkWidget(
                        text: "not_account".tr(),
                        fontWeight: FontWeight.bold,
                        function: _openSignUp),
                    const SizedBox(width: 10),
                    TextWithLinkWidget(
                        text: 'sign_up'.tr(),
                        color:
                            HiveDB.loadMode() ? Colors.blueGrey : Colors.blue,
                        function: _openSignUp),
                  ],
                )
              ],
            ),
            LoadingWidget(isLoading: isLoading)
          ],
        ),
      ),
    );
  }
}
