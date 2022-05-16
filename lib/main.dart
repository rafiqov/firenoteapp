import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenoteapp/pages/auth/sign_in/sign_in_page.dart';
import 'package:firenoteapp/pages/auth/sign_up/sign_up_page.dart';
import 'package:firenoteapp/pages/detail/detail_page.dart';
import 'package:firenoteapp/pages/home/home_page.dart';
import 'package:firenoteapp/services/auth_service.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/services/init_service.dart';
import 'package:firenoteapp/services/lang_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget startPage(BuildContext context) {
    return StreamBuilder<User?>(
        stream: AuthService.auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            HiveDB.storeUser(snapshot.data!);
            return const HomePage();
          } else {
            HiveDB.removeUser();
            return const SignInPage();
          }
        });
  }

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
          return GetMaterialApp(
            translations: LangService(),
            locale: LangService.locale,
            fallbackLocale: LangService.fallbackLocale,
            debugShowCheckedModeBanner: false,
            title: 'Fire Note App',
            themeMode: HiveDB.loadMode() ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: startPage(context),
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
