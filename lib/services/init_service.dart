import 'package:flutter_base_2024/controllers/app_controller.dart';
import 'package:flutter_base_2024/services/api_services.dart';
import 'package:flutter_base_2024/services/dialog_service.dart';
import 'package:flutter_base_2024/services/network_service.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'storage_service.dart';

initService() async {
  await Hive.initFlutter();
  StorageService storagetService = Get.put(StorageService());
  await storagetService.init();

  Get.put(ApiService());
  Get.put(NetworkService());
  Get.put(AppController());
  Get.put(StorageService());
  Get.put(DialogService());
}
