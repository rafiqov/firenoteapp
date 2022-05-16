import 'package:firenoteapp/pages/auth/sign_in/sign_in_controller.dart';
import 'package:firenoteapp/pages/auth/sign_up/sign_up_controller.dart';
import 'package:firenoteapp/pages/detail/detail_controller.dart';
import 'package:firenoteapp/pages/home/home_controller.dart';
import 'package:get/get.dart';

class DIService {
  static Future<void> init() async {
    Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
    Get.lazyPut<SignUpController>(() => SignUpController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<DetailController>(() => DetailController(), fenix: true);
  }
}
