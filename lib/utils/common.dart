import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:day/day.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_2024/constants/styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:math' as math;

String formatCryptoCurrency(String num) {
  try {
    if (double.parse(num) == 0) {
      return '0.00';
    }
    if (double.parse(num) < 1) {
      return num;
    }
    // format with specified decimal
    var f = NumberFormat("#,###.00######", "en_US");
    return f.format(double.parse(num));
  } catch (e) {
    return '0.00';
  }
}

String formatNumber(String num, {int decimal = 2}) {
  try {
    if (double.parse(num) == 0) {
      return '0.00';
    }
    if (double.parse(num) < 1) {
      return double.parse(num).toStringAsFixed(decimal);
    }
    // format with specified decimal
    var f = NumberFormat("#,###.${'0' * decimal}", "en_US");
    return f.format(double.parse(num));
  } catch (e) {
    return '0.00';
  }
}

String convertErrorMsg(msg) {
  try {
    var json = jsonDecode(msg.toString());
    String errorString = '';
    if (json is Map) {
      json.forEach((key, value) {
        if (value != null && value.length > 0) {
          errorString = '$errorString ${value[0]};';
        }
      });
    }
    return errorString;
  } catch (e) {
    return msg;
  }
}

void openUrl(String url) async {
  try {
    await launchUrlString(
      url,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    showError('Error', 'Invalid link');
  }
}

Future copy(String? text) async {
  if (text == null) {
    return;
  }
  try {
    await Clipboard.setData(ClipboardData(text: text));
    return true;
  } catch (e) {
    return false;
  }
}

EdgeInsets addPadding(double? top, double? bottom, double? left, double? right,
    {scale = defaultPadding}) {
  return EdgeInsets.only(
    top: (top ?? 0) * scale,
    bottom: (bottom ?? 0) * scale,
    left: (left ?? 0) * scale,
    right: (right ?? 0) * scale,
  );
}

SizedBox addSpace(times, {bool x = false}) {
  if (times == null || times == 0) {
    times = 1.0;
  }
  return SizedBox(
    width: x ? (defaultPadding * times) : 0,
    height: !x ? (defaultPadding * times) : 0,
  );
}

SizedBox addWidthSpace(times) {
  if (times == null || times == 0) {
    times = 1.0;
  }
  return SizedBox(
    width: (defaultPadding * times),
  );
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

// 客户端类型  pc, wap, ios, android
String getClientType() {
  if (Platform.isIOS) {
    return 'ios';
  } else {
    return 'android';
  }
}

Future<bool> checkConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}

/* show su/er */
void showSuccess([String? title, String? msg]) {
  if (msg == null || msg.isEmpty) {
    return;
  }
  Get.showSnackbar(GetSnackBar(
    title: title != null && title.isNotEmpty ? title : " ",
    message: msg.isNotEmpty ? msg : " ",
    backgroundColor: Colors.green,
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 3),
  ));
}

void showWarning([String? title, String? msg]) {
  if (msg == null || msg.isEmpty) {
    return;
  }
  Get.showSnackbar(GetSnackBar(
    title: title != null && title.isNotEmpty ? title : " ",
    message: msg.isNotEmpty ? msg : " ",
    backgroundColor: Colors.orange,
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 3),
  ));
}

void showError([String? title, String? msg]) {
  if (msg == null || msg.isEmpty) {
    return;
  }
  Get.showSnackbar(GetSnackBar(
    title: title != null && title.isNotEmpty ? title : " ",
    message: msg.isNotEmpty ? msg : " ",
    backgroundColor: Colors.red,
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 3),
  ));
}

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}

bool checkAppShdUpdate(version, criteria) {
  int v1Number = getExtendedVersionNumber(version);
  int v2Number = getExtendedVersionNumber(criteria);
  return v1Number < v2Number;
}

int getExtendedVersionNumber(String version) {
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
}

Future<Size> calculateImageDimension(String url) {
  Completer<Size> completer = Completer();
  Image image = Image.network(url);
  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        var myImage = image.image;

        Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
        completer.complete(size);
      },
    ),
  );
  return completer.future;
}

/// 根据照片获取对应Dimension
/// @params context
/// @params url 照片链接
/// @params percentage 宽度比例
///
/// return 对应高度
Future<double> transfromViewHeightBasedOnPercentage(
    BuildContext context, String url, double percentage) async {
  var size = await calculateImageDimension(url);
  var viewWidth = context.size!.width * percentage;
  var ratio = size.height / size.width;
  return viewWidth * ratio;
}

String dynamicFormatDate(String date, {String format = 'YYYY-MM-DD'}) {
  try {
    var initialDate = '';
    if (date.toString().isNum) {
      initialDate = Day.fromUnix(int.parse(date)).format(format);
    } else {
      initialDate = Day.fromString(date).format(format);
    }
    return initialDate;
  } catch (e) {
    return '';
  }
}

String uint8ListTob64(Uint8List uint8list) {
  String base64String = base64Encode(uint8list);
  String header = "data:image/png;base64,";
  return header + base64String;
}

// unit8List to File
File uint8ListToFile(Uint8List image) {
  var tempDir = Directory.systemTemp;
  File file = File('${tempDir.path}/temp.png');
  file.writeAsBytesSync(image);
  return file;
  // return File.fromRawPath(image);
}

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
  if (woy < 1) {
    woy = numOfWeeks(date.year - 1);
  } else if (woy > numOfWeeks(date.year)) {
    woy = 1;
  }
  return woy;
}

int numOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}

int numWeekOfCurrentYear() {
  var yearNum = DateTime.now().year;
  return numOfWeeks(yearNum);
}

int daysInMonth(DateTime date) {
  var firstDayThisMonth = DateTime(date.year, date.month, date.day);
  var firstDayNextMonth = DateTime(firstDayThisMonth.year,
      firstDayThisMonth.month + 1, firstDayThisMonth.day);
  return firstDayNextMonth.difference(firstDayThisMonth).inDays;
}

String dateWeekName(DateTime date) {
  return DateFormat('EEE').format(date);

  /// e.g Thursday
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Color randomColor() {
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
      .withOpacity(1.0);
}

String getPaymentName(key) {
  Map list = {
    'credit': 'credit_payment',
    'pay-online': 'bank_payment',
    'weixin-china': 'weixin-china',
  };

  return list[key];
}

String getDeliveryName(key) {
  Map list = {
    'by-post': 'delivery_by_post',
    'by-take-for-self': 'delivery_by_pick',
  };

  return list[key];
}

String getDurationofTwoDate(String start, String end) {
  if (start.isEmpty || end.isEmpty) {
    return '';
  }
  DateTime startDate = DateTime.parse(start);
  DateTime endDate = DateTime.parse(end);

  Duration duration = endDate.difference(startDate);
  int days = duration.inDays;
  int years = days ~/ 365;
  int months = (days % 365) ~/ 30;

  return "$years yr $months mos";
}

bool isNotEmpty(data) {
  return data != null && data != '';
}

String addressCombine(json) {
  String str = '';
  if (isNotEmpty(json['address_01'])) {
    str += json['address_01'];
  }
  if (isNotEmpty(json['address_02'])) {
    str += ', ';
    str += json['address_02'];
  }
  if (isNotEmpty(json['address_03'])) {
    str += ', ';
    str += json['address_03'];
  }
  if (isNotEmpty(json['address_04'])) {
    str += ', ';
    str += json['address_04'];
  }
  if (isNotEmpty(json['city'])) {
    str += ', ';
    str += json['city'];
  }
  if (isNotEmpty(json['postcode'])) {
    str += ', ';
    str += json['postcode'];
  }
  if (isNotEmpty(json['state'])) {
    str += ', ';
    str += json['state'];
    str += ', ';
  }
  if (isNotEmpty(json['country'])) {
    str += json['country'];
  }
  return str;
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

bool isAfter(DateTime date1, DateTime date2) {
  return date1.isAfter(date2);
}

bool isBefore(DateTime date1, DateTime date2) {
  return date1.isBefore(date2);
}

String throwEnterMsg(String text) {
  if (text.isEmpty) {
    return '';
  }
  return 'enter_placeholder'.tr.replaceFirst('{{placeholder}}', text);
}

String throwSelectMsg(String text) {
  if (text.isEmpty) {
    return '';
  }
  return 'select_placeholder'.tr.replaceFirst('{{placeholder}}', text);
}

String throwEmptyMsg(String text) {
  if (text.isEmpty) {
    return '';
  }
  return 'cannot_empty_placeholder'.tr.replaceFirst('{{placeholder}}', text);
}

String throwParamsLength(String text,
    {int length = 1, bool strict = true, bool isMax = false}) {
  if (text.isEmpty) {
    return '';
  }
  return strict
      ? 'params_length_required'
          .tr
          .replaceFirst('{{placeholder}}', text)
          .replaceFirst('{{length}}', length.toString())
      : isMax
          ? 'params_length_max'
              .tr
              .replaceFirst('{{placeholder}}', text)
              .replaceFirst('{{length}}', length.toString())
          : 'params_length_min'
              .tr
              .replaceFirst('{{placeholder}}', text)
              .replaceFirst('{{length}}', length.toString());
}

String throwParamsAlphanumeric(String text) {
  if (text.isEmpty) {
    return '';
  }
  return 'alphanumeric_required'.tr.replaceFirst('{{placeholder}}', text);
}

isAlphanumeric(String text) {
  // text shd be combination of letter and number
  RegExp reg = RegExp(r'^(?=.*\d)(?=.*[a-z])[a-zA-Z0-9]+$');

  return reg.hasMatch(text);
}

String throwParamsInvalid(String text) {
  if (text.isEmpty) {
    return '';
  }
  return 'params_invalid_placeholder'.trParams({'placeholder': text});
}

String cryptoHint({required String network, required String crypto}) {
  if (network.isEmpty || crypto.isEmpty) {
    return '';
  }
  return 'crypto_pay_remark'
      .tr
      .replaceFirst('{{network}}', network)
      .replaceFirst('{{crypto}}', crypto);
}

class StringUtils {
  StringUtils._();

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  static String capitalizeAll(String s) {
    return s
        .split(" ")
        .map((str) => capitalize(str))
        .reduce((value, element) => "$value $element");
  }

  static String capitalizeFirstOfEach(String s) {
    return s
        .split(" ")
        .map((str) => capitalize(str))
        .reduce((value, element) => "$value $element");
  }

  static String toCamelCase(String s) {
    return s
        .split(" ")
        .map((str) => capitalize(str))
        .reduce((value, element) => "$value$element");
  }

  static String toSnakeCase(String s) {
    return s
        .split(" ")
        .map((str) => str.toLowerCase())
        .reduce((value, element) => "${value}_$element");
  }

  static String selectPlaceholder(String text) {
    if (text.isEmpty) {
      return '';
    }
    return 'select_placeholder'.tr.replaceFirst('{{placeholder}}', text);
  }
}

String generateEncryptKey(data) {
  var json = jsonEncode(data);
  // convert json to base64
  var bytes = utf8.encode(json);
  var base64Str = base64.encode(bytes);
  var base64Length = base64Str.length;
  const fixedNum = 7305;
  int indexNum = fixedNum ~/ base64Length;
  // split index and total up
  var finalIndexed = indexNum
      .toString()
      .split('')
      .map((e) => int.parse(e))
      .reduce((value, element) {
    return value + element;
  });
  // generate 20 random characters
  String randomStr = randomString(20);
  // insert random characters into base64 string at index
  var newStr = base64Str.substring(0, finalIndexed.toInt()) +
      randomStr +
      base64Str.substring(finalIndexed.toInt());
  // add one character at 2nd index
  newStr = newStr.substring(0, 1) + randomString(1) + newStr.substring(1);
  return newStr;
}

randomString(int length) {
  const chars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#%^&*()_+{}[]<>?";
  var random = Random();
  var result = "";
  for (var i = 0; i < length; i++) {
    result += chars[random.nextInt(chars.length)];
  }
  return result;
}

// replace 60% of the string with *
String maskString(String str, {String? maskChar, double percentage = 0.6}) {
  if (str.isEmpty) {
    return '';
  }
  var length = str.length;
  var maskLength = (length * percentage).round();
  var maskStart = (length * (1 - percentage - 0.1)).round();
  var maskEnd = maskStart + maskLength;
  var maskedStr =
      str.replaceRange(maskStart, maskEnd, maskChar ?? '*' * maskLength);
  return maskedStr;
}

String wrapTextFnB(bool isWrap, String text,
    {String char = 'B', String symbol = '*'}) {
  if (text.isEmpty) {
    return '';
  }
  if (isWrap) {
    return '$char$symbol$text$symbol$char';
  }
  return text;
}

void getClipboardContent(context, {Function(String)? callback}) async {
  var data = await Clipboard.getData(Clipboard.kTextPlain);
  if (data != null && data.text != null) {
    callback!(data.text!);
  }
}

// add space in the word after every 4 characters
String addSpaceInWord(String str, {int space = 4}) {
  if (str.isEmpty) {
    return '';
  }
  var length = str.length;
  var newStr = '';
  for (var i = 0; i < length; i++) {
    if (i % space == 0 && i != 0) {
      newStr += ' ';
    }
    newStr += str[i];
  }
  return newStr;
}

String getCurrencySymbol(String? currency) {
  if (currency == null) {
    return '';
  }
  var symbol = '';
  if (currency.contains('USDT')) {
    symbol = 'USDT';
  } else if (currency.contains('_')) {
    symbol = currency.split('_')[0];
  } else {
    symbol = currency;
  }

  return symbol;
}

// 根据本金和利率计算12个月的复利 返回每个月的本金,利息和总额
List calculateCompoundInterest(double principal, double rate,
    {int month = 12}) {
  List result = [];
  for (var i = 1; i <= month; i++) {
    var interest = principal * rate;
    principal += interest;
    result.add({
      'month': i,
      'interest': interest.toStringAsFixed(2),
      'principal': (principal).toStringAsFixed(2),
      // 'total': (principal + interest).toStringAsFixed(2),
    });
  }
  return result;
}

// 根据本金和利率计算12个月的复利
String calculateCompoundInterestTotal(double principal, double rate,
    {int month = 12}) {
  var total = principal;
  for (var i = 1; i <= month; i++) {
    var interest = total * rate;
    total += interest;
  }
  return total.toStringAsFixed(2);
}
