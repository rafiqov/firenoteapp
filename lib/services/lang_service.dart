import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/services/locals/local_en.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'locals/local_uz.dart';

class LangService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enEN, // lang/en_us.dart

        'uz_UZ': uzUZ, // lang/uz_uz.dart
      };

  static const fallbackLocale = Locale('en', 'US');

  static final items = [
    'English',

    'O\'zbekcha',
  ];

  static final langs = ['en', 'uz'];

  static final List<Locale> locales = [
    const Locale('en', 'US'),
    const Locale('uz', 'UZ'),
  ];

  static final locale = defLanguage(HiveDB.loadLang());

  String defaultLanguage() {
    final locale = Get.locale;
    var lan = locale.toString();
    if (lan == "uz_UZ") return langs[1];
    return langs[0];
  }

  static Locale defLanguage(String code) {
    var index = langs.indexOf(code);
    return locales[index];
  }

  static void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    if (locale != null) {
      Get.updateLocale(locale);
      HiveDB.loadLang();
    }
  }

  static Locale? _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.deviceLocale;
  }
}
