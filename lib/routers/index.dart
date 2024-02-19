import 'package:flutter_base_2024/pages/splash.dart';
import 'package:get/get.dart';

class Routes {
  static const String splash = '/';
}

appRoutes() => [
      GetPage(
        name: Routes.splash,
        page: () => const SplashScreen(),
      ),
    ];
