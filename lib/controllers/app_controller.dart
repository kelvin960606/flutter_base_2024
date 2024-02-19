import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  CancelToken cancelToken = CancelToken();

  void forceLogout() {}
}
