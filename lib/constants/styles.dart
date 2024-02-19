import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const double defaultPadding = 16.0;

class FontType {
  FontType._();

  static const String defaultFont = 'Poppins';
  static const String defaultFontCN = 'HonorSansCN';
  static const String numbers = 'Lato';
}

class AppColor {
  AppColor._();

  static const Color primaryColor = Color(0xFF3A3A3A);
  static const Color secondaryColor = Color(0xFFE5E5E5);
  static const Color fontColor = Color(0xFF3A3A3A);
}

class FontStyle {
  FontStyle._();

  static TextStyle defaultFontStyle = const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    color: AppColor.fontColor,
  );

  static TextStyle defaultFontStyleCN = const TextStyle(
    fontFamily: 'HonorSansCN',
    fontWeight: FontWeight.w400,
    color: AppColor.fontColor,
  );

  static TextStyle numbers = const TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w400,
    color: AppColor.fontColor,
  );

  // function get font by size and type
  static TextStyle getFont(BuildContext context, int size,
      {FontWeight weight = FontWeight.w400, String? type}) {
    if (type == FontType.numbers) {
      return numbers.copyWith(fontSize: size.sp, fontWeight: weight);
    } else if (type == FontType.defaultFontCN) {
      return defaultFontStyleCN.copyWith(fontSize: size.sp, fontWeight: weight);
    } else if (type == FontType.defaultFont) {
      return defaultFontStyle.copyWith(fontSize: size.sp, fontWeight: weight);
    }
    // get locale
    var l = Get.locale;
    if (l == null) {
      return defaultFontStyle.copyWith(fontSize: size.sp, fontWeight: weight);
    }
    switch (l.languageCode) {
      case 'en':
        return defaultFontStyle.copyWith(fontSize: size.sp, fontWeight: weight);
      case 'zh':
        return defaultFontStyleCN.copyWith(
            fontSize: size.sp, fontWeight: weight);
      default:
        return defaultFontStyle.copyWith(fontSize: size.sp, fontWeight: weight);
    }
  }
}
