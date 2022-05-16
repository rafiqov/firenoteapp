import 'package:firenoteapp/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/hive_service.dart';

class DrawerWidget extends GetView<HomeController> {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  HomeController get controller => super.controller;

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
                "user_settings".tr,
                style: const TextStyle(fontSize: 16),
              ),
              DropdownButton<String>(
                itemHeight: 50,
                style: const TextStyle(fontSize: 16),
                alignment: Alignment.centerRight,
                underline: Container(),
                isDense: true,
                value: 'menu'.tr,
                items: <String>[
                  'menu'.tr,
                  'log_out'.tr,
                  'delete'.tr,
                  'add'.tr,
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(child: Text(value)),
                  );
                }).toList(),
                onChanged: (String? value) async {
                  controller.settingUser(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            Text(
              "change_mode".tr,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Icon(HiveDB.loadMode() ? Icons.dark_mode : Icons.light_mode),
            const SizedBox(width: 10),
            Switch(
                value: HiveDB.loadMode(),
                onChanged: (isMode) => controller.changeMode()),
          ]),
          Row(
            children: [
              Text(
                "change_lang".tr,
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              Image.asset(
                  'assets/images/ic_${controller.isEng ? 'en' : 'uz'}.png',
                  height: 50,
                  width: 50),
              const SizedBox(width: 10),
              Switch(
                  value: controller.isEng,
                  onChanged: (value) => controller.changeLang(value)),
            ],
          ),
        ],
      ),
    );
  }
}
