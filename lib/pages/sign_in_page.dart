import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenoteapp/pages/home_page.dart';
import 'package:firenoteapp/pages/sign_up_page.dart';
import 'package:firenoteapp/services/hive_service.dart';

import 'package:flutter/material.dart';

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
      content:  Text(text),
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
                textFile(name: " Email", controller: _emailController),
                const SizedBox(height: 10),
                textFile(name: " Password", controller: _passwordController),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  height: 50,
                  child: MaterialButton(
                    onPressed: doSignIn,
                    minWidth: 150,
                    child: const Text('Sign in'),
                    shape: const StadiumBorder(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWithLink(
                        text: 'Do not have an account?',
                        fontWeight: FontWeight.bold),
                    const SizedBox(width: 10),
                    textWithLink(
                        text: 'Sign Up',
                        color: Colors.blue,
                        function: _openSignUp),
                  ],
                )
              ],
            ),
            isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget textFile({required String name, controller}) {
    return Container(
      width: 150,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(border: InputBorder.none, hintText: name),
      ),
    );
  }

  Widget textWithLink(
      {required String text,
      function,
      color,
      FontWeight fontWeight = FontWeight.normal}) {
    return InkWell(
      onTap: function,
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontWeight: fontWeight)),
    );
  }
}
