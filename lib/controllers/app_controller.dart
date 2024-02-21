import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  CancelToken cancelToken = CancelToken();
  // pwa installer
  RxBool isPwaInstalled = false.obs;
  RxBool isPwaShow = true.obs;
  // main tab
  RxInt selectedMainTab = 0.obs;

  void onTabChange(int index) {
    selectedMainTab.value = index;
  }

  void forceLogout() {}
}
