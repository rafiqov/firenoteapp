import 'package:firenoteapp/models/note_models.dart';
import 'package:firenoteapp/pages/detail/detail_page.dart';
import 'package:firenoteapp/pages/auth/sign_up/sign_up_page.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/services/lang_service.dart';
import 'package:firenoteapp/services/real_time_database_service.dart';
import 'package:firenoteapp/views/functions_common.dart';
import 'package:get/get.dart';

import '../auth/sign_in/sign_in_page.dart';
import '../../services/auth_service.dart';

class HomeController extends GetxController {
  bool isLoading = false;
  List<Note> notes = [];
  bool isEng = false;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() async {
    isLoading = true;
    update();
    String userId = HiveDB.loadUser();
    notes = await RealTimeDataBase.getPosts(userId);
    isLoading = false;
    update();
  }

  void openDetailPage() async {
    var res = await Get.to(() => const DetailPage());
    if (res as bool) {
      isLoading = true;
      update();
      String userId = HiveDB.loadUser();
      notes = await RealTimeDataBase.getPosts(userId);
      isLoading = false;
      update();
    }
  }

  void removeNote(Note note) async {
    isLoading = true;
    update();
    await RealTimeDataBase.deletePost(note);
    String userId = HiveDB.loadUser();
    notes = await RealTimeDataBase.getPosts(userId);
    isLoading = false;
    update();
  }

  void openDetailForEdit(Note note) async {
    var result = await Get.to(() => const DetailPage(), arguments: note);

    if (result != null && result == true) {
      String userId = HiveDB.loadUser();
      notes = await RealTimeDataBase.getPosts(userId);
      isLoading = false;
      update();
    }
  }

  void changeMode() {
    HiveDB.storeMode(!HiveDB.loadMode());
    update();
  }

  void openSignUp() => Get.off(() => const SignUpPage());

  void openSignIn() {
    HiveDB.removeUser();
    AuthService.signOutUser();
    Get.off(() => const SignInPage());
  }

  void settingUser(String? value) {
    if (value == 'log_out'.tr) {
      openSignIn();
    } else if (value == 'delete'.tr) {
      AuthService.removeUser();
      openSignUp();
      UtilsCommon.showSnackBar("delete_user".tr);
    } else if (value == 'add'.tr) {
      UtilsCommon.showSnackBar("add_user".tr);
      update();
      openSignUp();
    }
  }

  void changeLang(bool value) {
    LangService.changeLocale(value ? 'en' : "ru");
    update();
  }
}
