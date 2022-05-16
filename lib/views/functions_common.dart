import 'package:firenoteapp/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UtilsCommon {
  static void showSnackBar(String text) {
    Get.snackbar(
      text.tr,
      '',
      backgroundColor:
          HiveDB.loadMode() ? Colors.grey.shade600 : Colors.grey.shade200,
    );
  }
}
