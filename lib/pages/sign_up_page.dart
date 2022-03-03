import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenoteapp/commons/functions_common.dart';
import 'package:firenoteapp/commons/loading_widget.dart';
import 'package:firenoteapp/pages/sign_in_page.dart';
import 'package:firenoteapp/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../commons/main_button.dart';
import '../commons/text_field_common_widget.dart';
import '../commons/text_with_link.dart';
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
      FunctionCommon.showSnackBar(text: 'Wrong something', context: context);
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
      FunctionCommon.showSnackBar(text: AuthService.snackBar!, context: context);
      setState(() => isLoading = false);
    }
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
                TextFieldWidget(
                    name: "firstname".tr(), controller: _firstNameController),
                const SizedBox(height: 10),
                TextFieldWidget(name: "email".tr(), controller: _emailController),
                const SizedBox(height: 10),
                TextFieldWidget(
                    name: "lastname".tr(), controller: _lastNameController),
                const SizedBox(height: 10),
                TextFieldWidget(
                    name: "password".tr(), controller: _passwordController),
                const SizedBox(height: 10),
                MainButton(
                  name: 'sign_up'.tr(),
                  function: doSignUp,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWithLinkWidget(
                        text: "have_account".tr(),
                        fontWeight: FontWeight.bold),
                    const SizedBox(width: 10),
                    TextWithLinkWidget(
                        text: 'sign_in'.tr(),
                        color: HiveDB.loadMode() ? Colors.blueGrey : Colors.blue,
                        function: _openSignIn),
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

