import 'package:easy_localization/easy_localization.dart';
import 'package:firenoteapp/commons/functions_common.dart';
import 'package:flutter/material.dart';

import '../pages/sign_in_page.dart';
import '../pages/sign_up_page.dart';
import '../services/auth_service.dart';
import '../services/hive_service.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool isEng = false;

  void changeMode() => setState(() => HiveDB.storeMode(!HiveDB.loadMode()));

  void _openSignUp() => Navigator.pushReplacementNamed(context, SignUpPage.id);

  void _openSignIn() {
    HiveDB.removeUser();
    AuthService.signOutUser(context);
    print(HiveDB.loadUser());
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "user_settings".tr(),
                style: const TextStyle(fontSize: 16),
              ),
              DropdownButton<String>(
                itemHeight: 50,
                style: const TextStyle(fontSize: 16),
                alignment: Alignment.centerRight,
                underline: Container(),
                isDense: true,
                value: 'menu'.tr(),
                items: <String>[
                  'menu'.tr(),
                  'log_out'.tr(),
                  'delete'.tr(),
                  'add'.tr(),
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(child: Text(value)),
                  );
                }).toList(),
                onChanged: (String? value) async {
                  if (value == 'log_out'.tr()) {
                    _openSignIn();
                  } else if (value == 'delete'.tr()) {
                    AuthService.removeUser(context);
                    FunctionCommon.showSnackBar(
                        text: "delete_user".tr(), context: context);
                    setState(() {});
                  } else if (value == 'add'.tr()) {
                    FunctionCommon.showSnackBar(
                        text: "add_user".tr(), context: context);
                    setState(() {});
                    _openSignUp();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            Text(
              "change_mode".tr(),
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Icon(HiveDB.loadMode() ? Icons.dark_mode : Icons.light_mode),
            const SizedBox(width: 10),
            Switch(
                value: HiveDB.loadMode(),
                onChanged: (isMode) {
                  setState(() {
                    HiveDB.storeMode(isMode);
                  });
                }),
          ]),
          Row(
            children: [
              Text(
                "change_lang".tr(),
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              Image.asset('assets/images/ic_${isEng ? 'en' : 'uz'}.png',
                  height: 50, width: 50),
              const SizedBox(width: 10),
              Switch(
                  value: isEng,
                  onChanged: (value) {
                    setState(() {
                      isEng = value;
                      if (isEng) {
                        context.setLocale(const Locale('en', 'US'));
                      } else {
                        context.setLocale(const Locale('uz', 'UZ'));
                      }
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
