import 'package:flutter/material.dart';

import '../services/hive_service.dart';

class TextFieldWidget extends StatelessWidget {
  final String name;
  final TextEditingController controller;

  const TextFieldWidget({
    Key? key,
    required this.name,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      decoration: BoxDecoration(
        color: HiveDB.loadMode() ? Colors.grey.shade700 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(border: InputBorder.none, hintText: name),
      ),
    );
  }
}
