import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';


class HiveDB {
  static const String dbName = 'flutter_bin';
  static var box = Hive.box(dbName);

  // #user
  static void storeUser(User user) async => box.put('user', user.uid);

  static String loadUser() => box.get('user');

  static void removeUser() async => await box.delete('user');

  // // #language
  static void storeLang(String lang) async => box.put('lang', lang);

  static String loadLang() => box.get('lang');

  // #mode
  static void storeMode(bool isMode) async => box.put('isMode', isMode);

  static bool loadMode() => box.get('isMode', defaultValue: true);

}
