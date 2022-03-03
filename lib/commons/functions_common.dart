import 'package:firenoteapp/services/hive_service.dart';
import 'package:flutter/material.dart';

class FunctionCommon {
  static void showSnackBar(
      {required String text, required BuildContext context}) {
    final snackBar = SnackBar(
      backgroundColor:
          HiveDB.loadMode() ? Colors.grey.shade600 : Colors.grey.shade200,
      content: Text(text),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
