import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_2024/constants/styles.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'components/web_frame.dart';
import 'routers/index.dart';
import 'translation/index.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
    statusBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return FlutterWebFrame(
          builder: (context) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              translations: Messages(),
              fallbackLocale: const Locale('en', 'US'),
              locale: const Locale('zh', 'CN'),
              theme: ThemeData(
                fontFamily: FontType.defaultFont,
                primarySwatch: Colors.blue,
              ),
              initialRoute: Routes.splash,
              getPages: appRoutes(),
              builder: EasyLoading.init(
                builder: (context, child) {
                  child = Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: GestureDetector(
                      onTap: () => hideKeyboard(context),
                      child: child,
                    ),
                  );
                  final mediaQueryData = MediaQuery.of(context);

                  return MediaQuery(
                    data: mediaQueryData.copyWith(textScaleFactor: 1.0),
                    child: child,
                  );
                },
              ),
            );
          },
          maximumSize: const Size(375, 812),
          enabled: kIsWeb,
          backgroundColor: Colors.grey,
        );
      },
    );
  }
}
