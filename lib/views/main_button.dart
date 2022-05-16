import 'package:firenoteapp/services/hive_service.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Function? function;
  final String name;

  const MainButton({
    required this.name,
    this.function,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      height: 50,
      child: MaterialButton(
        onPressed: function != null ? () => function!() : () {},
        child: Text(name, style: const TextStyle(fontSize: 16)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: HiveDB.loadMode() ? Colors.blueGrey : Colors.blue,
      ),
    );
  }
}
