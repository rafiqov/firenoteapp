import 'package:firebase_core/firebase_core.dart';
import 'package:firenoteapp/services/di_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'configuration_services.dart';
import 'hive_service.dart';

class InitService {
  static Future<void> init() async {
    await DIService.init();
    await Hive.initFlutter();
    await Hive.openBox(HiveDB.dbName);
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: Configurations.apiKey,
          storageBucket: Configurations.storageBucket,
          appId: Configurations.appId,
          messagingSenderId: Configurations.messagingSenderId,
          projectId: Configurations.projectId),
    );
  }
}
