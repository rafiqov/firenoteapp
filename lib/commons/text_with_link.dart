import 'package:flutter/material.dart';

class TextWithLinkWidget extends StatelessWidget {
  String text;
  Function? function;
  Color? color;
  FontWeight fontWeight;

  TextWithLinkWidget(
      {required this.text,
      this.function,
      this.color,
      this.fontWeight = FontWeight.normal,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function!(),
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontWeight: fontWeight)),
    );
  }
}
