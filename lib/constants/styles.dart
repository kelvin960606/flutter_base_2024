import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  static TextStyle getFont(double size,
      {FontWeight weight = FontWeight.w400, String? type}) {
    switch (type) {
      case FontType.defaultFont:
        return defaultFontStyle.copyWith(fontSize: size, fontWeight: weight);
      case FontType.defaultFontCN:
        return defaultFontStyleCN.copyWith(fontSize: size, fontWeight: weight);
      case FontType.numbers:
        return numbers.copyWith(fontSize: size, fontWeight: weight);
      default:
        return defaultFontStyle.copyWith(fontSize: size, fontWeight: weight);
    }
  }
}
