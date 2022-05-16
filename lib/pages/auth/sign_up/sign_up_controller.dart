import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenoteapp/pages/auth/sign_in/sign_in_page.dart';
import 'package:firenoteapp/services/auth_service.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/views/functions_common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void doSignUp() async {
    String firstName = firstNameController.text.trim().toString();
    String email = emailController.text.trim().toString();
    String lastName = lastNameController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if (firstName.isEmpty ||
        email.isEmpty ||
        lastName.isEmpty ||
        password.isEmpty) {
      UtilsCommon.showSnackBar('Wrong something');
      return;
    }
    isLoading = true;
    update();
    await AuthService.signUpUser(firstName + ' ' + lastName, email, password)
        .then((user) => _getFireBaseUser(user));
  }

  _getFireBaseUser(User? user) {
    if (user != null) {
      isLoading = false;
      update();
      HiveDB.storeUser(user);
      openSignIn();
    } else {
      UtilsCommon.showSnackBar(AuthService.snackBar!);
      isLoading = false;
      update();
    }
  }

  void openSignIn() => Get.off(() => const SignInPage());
}
