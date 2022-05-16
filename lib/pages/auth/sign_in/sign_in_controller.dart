import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenoteapp/pages/home/home_page.dart';
import 'package:firenoteapp/pages/auth/sign_up/sign_up_page.dart';
import 'package:firenoteapp/services/auth_service.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/views/functions_common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void doSignIn() async {
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if (email.isEmpty || password.isEmpty) {
      UtilsCommon.showSnackBar('Wrong something');
      return;
    }

    isLoading = true;
    update();
    var user = await AuthService.signInUser(email, password);
    _getFireBaseUser(user);
  }

  _getFireBaseUser(User? user) {
    isLoading = true;
    update();
    if (user != null) {
      HiveDB.storeUser(user);
      openHome();
    } else {
      UtilsCommon.showSnackBar(AuthService.snackBar!);
    }
    isLoading = false;
    update();
  }

  void openSignUp() => Get.off(() => const SignUpPage());

  void openHome() => Get.off(() => const HomePage());
}
