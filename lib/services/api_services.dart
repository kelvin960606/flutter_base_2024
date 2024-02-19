import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base_2024/constants/env.dart';
import 'package:flutter_base_2024/controllers/app_controller.dart';
import 'package:flutter_base_2024/services/storage_service.dart';
import 'package:flutter_base_2024/utils/api_exception.dart';
import 'package:flutter_base_2024/utils/common.dart';
import 'package:flutter_base_2024/utils/pretty_logger.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';

class ApiType {
  static String get = 'get';
  static String post = 'post';
  static String delete = 'delete';
  static String patch = 'patch';
  static String put = 'put';
}

class ApiService extends GetxService {
  final StorageService _storageService = Get.find();
  dio.Dio client = dio.Dio(dio.BaseOptions(
    receiveTimeout: const Duration(seconds: 60),
    headers: {},
    validateStatus: (status) => status! >= 200 && status <= 500,
  ));

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    client.options.baseUrl = '$apiUrl/api';
    if (!kIsWeb && kDebugMode) {
      PrettyDioLogger logger = PrettyDioLogger(
        responseBody: true,
        responseHeader: false,
      );
      client.interceptors.add(logger);
    }
  }

  Future uploadFile(
    String path,
    List<int> bytes, {
    String? fileName,
    String? fileExtension,
    String? contentType,
    Map<String, dynamic>? data,
  }) async {
    try {
      var formData = dio.FormData.fromMap({
        'file': dio.MultipartFile.fromBytes(
          bytes,
          filename: fileName,
          contentType: MediaType.parse(contentType ?? 'image/jpeg'),
        ),
      });
      if (data != null) {
        formData.fields
            .addAll(data.entries.map((e) => MapEntry(e.key, e.value)));
      }
      var response = await client.post(path, data: formData);
      return _returnResponse(response, false);
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      if (e.response != null) {
        return _returnResponse(e.response!, false);
      } else {
        return {'success': false, 'message': ''};
      }
    }
  }

  Future apiRequest({
    required String path,
    required String type,
    required bool withToken,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? encryptString,
    bool isCulture = true,
  }) async {
    final AppController appController = Get.find();
    dynamic response;
    Future jsonResponse;
    try {
      client.options.headers.clear();
      if (headers != null) {
        client.options.headers.addAll(headers);
      }
      if (withToken) {
        var token = _storageService.getUserToken();

        if (token != null) {
          client.options.headers['Authorization'] = 'Bearer $token';
        } else {
          return {
            'success': false,
            'message': 'tokenExpired'.tr,
          };
        }
      }
      client.options.headers['Content-Type'] = 'application/json;charset=utf-8';
      Map<String, dynamic> query = {};
      if (isCulture) {
        var lang = _storageService.getLang() ?? 'zh-cn';
        if (lang.contains('en')) {
          lang = 'en';
        }
        if (data != null) {
          query['culture'] = lang;
        } else {
          query = {'culture': lang};
        }
      }
      if (type == ApiType.get) {
        query.addAll(data ?? {});
      }

      if (type == ApiType.get) {
        response = await client.get(path,
            queryParameters: data, cancelToken: appController.cancelToken);
      } else if (type == ApiType.post) {
        response = await client.post(path,
            data: data, cancelToken: appController.cancelToken);
      } else if (type == ApiType.put) {
        response = await client.put(path,
            data: data, cancelToken: appController.cancelToken);
      } else if (type == ApiType.delete) {
        response = await client.delete(path,
            data: data, cancelToken: appController.cancelToken);
      } else if (type == ApiType.patch) {
        response = await client.patch(path,
            queryParameters: data, cancelToken: appController.cancelToken);
      } else {
        response = await client.get(path);
      }

      jsonResponse = _returnResponse(response, withToken);
      return jsonResponse;
    } on DioException {
      // showWarning('tips'.tr, 'network_error'.tr);
      return {'success': false, 'message': ''};
    } on SocketException {
      throw Failure(message: 'StringConstants.noConnectionError');
    } on FormatException {
      throw Failure(message: 'StringConstants.formatError');
    } catch (e) {
      // showError('error'.tr, e.toString());
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<dynamic> _returnResponse(dio.Response response, bool withToken) async {
    var path = response.realUri.path.toString();
    if (response.toString().isEmpty) {
      if (kDebugMode) {
        showError('error'.tr, '$path 接口返回空白');
      }
      // if the response is empty, it means that the endpoint is not published
      return {'success': false, 'message': '接口返回空白'};
    }
    // convert the response to a map
    // final Map<String, dynamic> jsonResponse = json.decode(response.toString());
    // convert the map to a ErrorResponse object
    // ErrorResponse error = ErrorResponse.fromJson(jsonResponse);

    switch (response.statusCode) {
      case 200:
        // if the response status code is 200, convert the response to a map
        var responseJson = json.decode(response.toString());
        if (withToken && responseJson["code"] == 401) {
          // if the response contains a checkToken field and the value is 2, the token is invalid, and the user needs to be forced to log out
          await _forceLogout();
          showWarning('tips'.tr, responseJson['message'] ?? 'tokenExpired'.tr);
          return {'success': false, 'message': ''};
        } else {
          // the response is normal, return the response
          return responseJson;
        }
      case 400:
        // if the response status code is 400, convert the response to a map
        var responseJson = json.decode(response.toString());
        // return the response
        return responseJson;
      case 401:
        if (withToken) {
          // if the response status code is 401 and the request contains a token, the token is invalid, and the user needs to be forced to log out
          await _forceLogout();
        }
        break;
      case 403:
        throw Failure(message: 'Token expired');
      case 404:
        if (kDebugMode) {
          showError('error'.tr, '$path 接口不存在');
        }
        return {'success': false, 'message': ''};
      case 429:
        return {'success': false, 'message': '请求过于频繁，请稍后再试'};
      case 500:
      default:
        // if the response status code is other, the request is wrong, and the error message is returned
        throw Failure(
            message:
                'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<void> _forceLogout() async {
    final AppController appController = Get.find();
    appController.forceLogout();
  }
}
