import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenoteapp/pages/sign_in_page.dart';
import 'package:firenoteapp/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../services/hive_service.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'sign_up_page';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void doSignUp() async {
    String firstName = _firstNameController.text.trim().toString();
    String email = _emailController.text.trim().toString();
    String lastName = _lastNameController.text.trim().toString();
    String password = _passwordController.text.trim().toString();

    if (firstName.isEmpty ||
        email.isEmpty ||
        lastName.isEmpty ||
        password.isEmpty) {
      showSnackBar(text: 'Wrong something');
      return;
    }
    setState(() => isLoading = true);
    await AuthService.signUpUser(firstName + ' ' + lastName, email, password)
        .then((user) => _getFireBaseUser(user));
  }

  _getFireBaseUser(User? user) {
    if (user != null) {
      setState(() => isLoading = false);
      HiveDB.storeUser(user);
      _openSignIn();
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

  void _openSignIn() => Navigator.pushReplacementNamed(context, SignInPage.id);

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

                textFile(name: " First Name", controller: _firstNameController),
                const SizedBox(height: 10),
                textFile(name: " Email", controller: _emailController),
                const SizedBox(height: 10),
                textFile(name: " Last Name", controller: _lastNameController),
                const SizedBox(height: 10),
                textFile(name: " Password", controller: _passwordController),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  height: 50,
                  child: MaterialButton(
                    onPressed: doSignUp,
                    minWidth: 150,
                    child: const Text('Sign Up'),
                    shape: const StadiumBorder(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWithLink(
                        text: 'Do have an account?',
                        fontWeight: FontWeight.bold),
                    const SizedBox(width: 10),
                    textWithLink(
                        text: 'Sign In',
                        color: Colors.blue,
                        function: _openSignIn),
                  ],
                )
              ],
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink()
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
      Color color = Colors.black,
      FontWeight fontWeight = FontWeight.normal}) {
    return InkWell(
      onTap: function,
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontWeight: fontWeight)),
    );
  }
}
