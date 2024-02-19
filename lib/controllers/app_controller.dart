import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  CancelToken cancelToken = CancelToken();
  // pwa installer
  RxBool isPwaInstalled = false.obs;
  RxBool isPwaShow = true.obs;
  void forceLogout() {}
}
