import 'package:flutter/material.dart';

class TextWithLinkWidget extends StatelessWidget {
  final String text;
  final Function? function;
  final Color? color;
  final FontWeight fontWeight;

  const TextWithLinkWidget(
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
