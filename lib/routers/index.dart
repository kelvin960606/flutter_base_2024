import 'package:flutter_base_2024/pages/landing.dart';
import 'package:flutter_base_2024/pages/login.dart';
import 'package:flutter_base_2024/pages/splash.dart';
import 'package:get/get.dart';

class Routes {
  static const String splash = '/';
  static const String landing = '/landing';
  static const String login = '/login';
}

appRoutes() => [
      GetPage(
        name: Routes.splash,
        page: () => const SplashScreen(),
      ),
      GetPage(
        name: Routes.login,
        page: () => const LoginScreen(),
      ),
      GetPage(
        name: Routes.landing,
        page: () => const LandingScreen(),
      ),
    ];
