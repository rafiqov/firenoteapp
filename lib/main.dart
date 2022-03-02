import 'package:firebase_core/firebase_core.dart';
import 'package:firenoteapp/pages/detail_page.dart';
import 'package:firenoteapp/pages/home_page.dart';
import 'package:firenoteapp/pages/sign_in_page.dart';
import 'package:firenoteapp/pages/sign_up_page.dart';
import 'package:firenoteapp/services/configuration_services.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.DB_NAME);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: Configurations.apiKey,
        appId: Configurations.appId,
        messagingSenderId: Configurations.messagingSenderId,
        projectId: Configurations.projectId),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));
    return ValueListenableBuilder(
        valueListenable: HiveDB.box.listenable(),
        builder: (BuildContext context, box, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Fire Note App',
            themeMode: HiveDB.loadMode() ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const SignInPage(),
            routes: {
              HomePage.id: (context) => const HomePage(),
              SignInPage.id: (context) => const SignInPage(),
              SignUpPage.id: (context) => const SignUpPage(),
              DetailPage.id: (context) => const DetailPage(),
            },
          );
        });
  }
}
