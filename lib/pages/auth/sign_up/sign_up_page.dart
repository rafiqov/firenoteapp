import 'package:firenoteapp/pages/auth/sign_up/sign_up_controller.dart';
import 'package:firenoteapp/views/loading_widget.dart';
import 'package:firenoteapp/views/main_button.dart';
import 'package:firenoteapp/views/text_field_common_widget.dart';
import 'package:firenoteapp/views/text_with_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/hive_service.dart';

class SignUpPage extends GetView<SignUpController> {
  static const String id = 'sign_up_page';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  SignUpController get controller => super.controller;

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
                    name: "firstname".tr,
                    controller: controller.firstNameController),
                const SizedBox(height: 10),
                TextFieldWidget(
                    name: "email".tr, controller: controller.emailController),
                const SizedBox(height: 10),
                TextFieldWidget(
                    name: "lastname".tr,
                    controller: controller.lastNameController),
                const SizedBox(height: 10),
                TextFieldWidget(
                    name: "password".tr,
                    controller: controller.passwordController),
                const SizedBox(height: 10),
                MainButton(
                  name: 'sign_up'.tr,
                  function: controller.doSignUp,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWithLinkWidget(
                        text: "have_account".tr, fontWeight: FontWeight.bold),
                    const SizedBox(width: 10),
                    TextWithLinkWidget(
                        text: 'sign_in'.tr,
                        color:
                            HiveDB.loadMode() ? Colors.blueGrey : Colors.blue,
                        function: controller.openSignIn),
                  ],
                )
              ],
            ),
            LoadingWidget(isLoading: controller.isLoading)
          ],
        ),
      ),
    );
  }

}

