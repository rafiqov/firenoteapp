import 'package:firenoteapp/pages/auth/sign_in/sign_in_controller.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/views/loading_widget.dart';
import 'package:firenoteapp/views/main_button.dart';
import 'package:firenoteapp/views/text_field_common_widget.dart';
import 'package:firenoteapp/views/text_with_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInPage extends GetView<SignInController> {
  static const String id = '/sign_in_page';

  @override
  SignInController get controller => super.controller;

  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<SignInController>(
          init: SignInController(),
          builder: (_controller) {
            return Scaffold(
              body: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                          name: "email".tr,
                          controller: _controller.emailController),
                      const SizedBox(height: 10),
                      TextFieldWidget(
                          name: "password".tr,
                          controller: _controller.passwordController),
                      const SizedBox(height: 10),
                      MainButton(
                          function: _controller.doSignIn, name: 'sign_in'.tr),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWithLinkWidget(
                              text: "not_account".tr,
                              fontWeight: FontWeight.bold,
                              function: _controller.openSignUp),
                          const SizedBox(width: 10),
                          TextWithLinkWidget(
                              text: 'sign_up'.tr,
                              color: HiveDB.loadMode()
                                  ? Colors.blueGrey
                                  : Colors.blue,
                              function: _controller.openSignUp),
                        ],
                      )
                    ],
                  ),
                  LoadingWidget(isLoading: _controller.isLoading)
                ],
              ),
            );
          }),
    );
  }
}
