import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Routes {
  static const String splash = '/';
}

appRoutes() => [
      GetPage(
        name: Routes.splash,
        page: () => Container(),
      ),
    ];
