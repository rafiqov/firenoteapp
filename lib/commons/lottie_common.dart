import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class LottieCommon extends StatelessWidget {
  LottieEnum lottieEnum;
  double size;

  LottieCommon({Key? key, this.lottieEnum = LottieEnum.placeholder, this.size = 45})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (lottieEnum) {
      case LottieEnum.placeholder:
        return Lottie.asset('assets/lottie/placeholder_lottie.json',
            height: size,
            width: size,
            fit: BoxFit.cover);
      case LottieEnum.error:
        return Lottie.asset('assets/lottie/error_lottie.json',
            height: size,
            width: size,
            repeat: false, fit: BoxFit.cover);
    }
  }
}

enum LottieEnum { placeholder, error }
