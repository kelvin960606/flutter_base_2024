import 'dart:math' as math;

// import 'package:countly_flutter/countly_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PrettyDioLogger extends Interceptor {
  /// Print request [Options]
  final bool request;

  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print error message
  final bool error;

  /// InitialTab count to logPrint json response
  static const int initialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per logPrint
  final int maxWidth;

  /// Handle extra resposne action
  Function? responseAddOn;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  void Function(Object object) logPrint;

  int maxLength = 9999;

  PrettyDioLogger(
      {this.request = true,
      this.requestHeader = true,
      this.requestBody = true,
      this.responseHeader = true,
      this.responseBody = true,
      this.error = true,
      this.maxWidth = 120,
      this.compact = true,
      this.logPrint = print,
      this.responseAddOn});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (request) {
      _printRequestHeader(options);
    }
    if (requestHeader) {
      _printMapAsTable(options.queryParameters, header: 'Query Parameters');
      final requestHeaders = <String, dynamic>{};
      requestHeaders.addAll(options.headers);
      requestHeaders['contentType'] = options.contentType?.toString();
      requestHeaders['responseType'] = options.responseType.toString();
      requestHeaders['followRedirects'] = options.followRedirects;
      requestHeaders['connectTimeout'] = options.connectTimeout;
      requestHeaders['receiveTimeout'] = options.receiveTimeout;
      _printMapAsTable(requestHeaders, header: 'Headers');
      _printMapAsTable(options.extra, header: 'Extras');
    }
    if (requestBody && options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data.toString().length < 100 && data is Map) {
          _printMapAsTable(options.data as Map, header: 'Body');
        }
        if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          _printMapAsTable(formDataMap, header: 'Form data | ${data.boundary}');
        } else {
          _printBlock(data.toString());
        }
      }
    }
    // super.onRequest(options, handler);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _printResponseHeader(response);
    if (responseHeader) {
      final responseHeaders = <String, String>{};
      response.headers
          .forEach((k, list) => responseHeaders[k] = list.toString());
      _printMapAsTable(responseHeaders, header: 'Headers');
    }

    if (responseBody) {
      debugPrint('╔ Body');
      debugPrint('║');
      _printResponse(response);
      debugPrint('║');
      _printLine('╚');
    }
    if (responseAddOn != null) {
      responseAddOn!(response);
    }
    // super.onResponse(response, handler);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (error) {
      if (err.type == DioExceptionType.connectionTimeout) {
        _printBoxed(
            header: 'DioError ║ ${err.type} ${err.requestOptions.uri}',
            text: err.message);
        // String exception = 'DioError ║ 接口超时: ${err.requestOptions.uri}';
        // Countly.logExceptionManual(exception, true);
      } else if (err.type == DioExceptionType.badResponse) {
        final uri = err.response!.requestOptions.uri;
        _printBoxed(
            header:
                'DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage}',
            text: uri.toString());
        if (err.response != null && err.response?.data != null) {
          debugPrint('╔ ${err.type.toString()}');
          _printResponse(err.response!);
        }
        _printLine('╚');
        debugPrint('');
      } else {
        _printBoxed(
            header: 'DioError ║ ${err.type} ${err.requestOptions.uri}',
            text: err.message);
      }
    }
    // super.onError(err, handler);
    handler.next(err);
  }

  void _printBoxed({String? header, String? text}) {
    debugPrint('');
    debugPrint('╔╣ $header');
    debugPrint('║  $text');
    _printLine('╚');
  }

  void _printResponse(Response response) {
    if (response.data != null) {
      if (response.data.toString().isEmpty) {
        _printBlock('接口返回空白');
        return;
      }
      // if response data is too long, do not print it.
      if (response.data.toString().length > maxLength) {
        return;
      }
      if (response.data is Map) {
        _printPrettyMap(response.data as Map);
      } else if (response.data is List) {
        debugPrint('║${_indent()}[');
        _printList(response.data as List);
        debugPrint('║${_indent()}[');
      } else {
        _printBlock(response.data.toString());
      }
    }
  }

  void _printResponseHeader(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    _printBoxed(
        header:
            'Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage}',
        text: uri.toString());
  }

  void _printRequestHeader(RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    _printBoxed(header: 'Request ║ $method ', text: uri.toString());
  }

  void _printLine([String pre = '', String suf = '╝']) =>
      debugPrint('$pre${'═' * maxWidth}$suf');

  void _printKV(String key, dynamic v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      debugPrint(pre);
      _printBlock(msg);
    } else {
      debugPrint('$pre$msg');
    }
  }

  void _printBlock(String msg) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      debugPrint((i >= 0 ? '║ ' : '') +
          msg.substring(i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  String _indent([int tabCount = initialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    Map data, {
    int tabs = initialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var t = tabs;
    final isRoot = t == initialTab;
    final initialIndent = _indent(t);
    t++;

    if (isRoot || isListItem) debugPrint('║$initialIndent{');

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'(\r|\n)+'), " ")}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value)) {
          debugPrint('║${_indent(t)} $key: $value${!isLast ? ',' : ''}');
        } else {
          debugPrint('║${_indent(t)} $key: {');
          _printPrettyMap(value, tabs: t);
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value)) {
          debugPrint('║${_indent(t)} $key: ${value.toString()}');
        } else {
          debugPrint('║${_indent(t)} $key: [');
          _printList(value, tabs: t);
          debugPrint('║${_indent(t)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(t);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            debugPrint(
                '║${_indent(t)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}');
          }
        } else {
          debugPrint('║${_indent(t)} $key: $msg${!isLast ? ',' : ''}');
        }
      }
    });

    debugPrint('║$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  void _printList(List list, {int tabs = initialTab}) {
    list.asMap().forEach((i, dynamic e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && _canFlattenMap(e)) {
          debugPrint('║${_indent(tabs)}  $e${!isLast ? ',' : ''}');
        } else {
          _printPrettyMap(e, tabs: tabs + 1, isListItem: true, isLast: isLast);
        }
      } else {
        debugPrint('║${_indent(tabs + 2)} $e${isLast ? '' : ','}');
      }
    });
  }

  bool _canFlattenMap(Map map) {
    return map.values
            .where((dynamic val) => val is Map || val is List)
            .isEmpty &&
        map.toString().length < maxWidth;
  }

  bool _canFlattenList(List list) {
    return list.length < 10 && list.toString().length < maxWidth;
  }

  void _printMapAsTable(Map? map, {String? header}) {
    if (map!.isEmpty) return;
    debugPrint('╔ $header ');
    map.forEach(
        (dynamic key, dynamic value) => _printKV(key.toString(), value));
    _printLine('╚');
  }
}
