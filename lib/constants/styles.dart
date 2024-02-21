import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const double defaultPadding = 16.0;
List<BoxShadow> cardShadow = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.3),
    spreadRadius: 3,
    blurRadius: 2,
    offset: const Offset(0, 2),
  ),
];

class FontType {
  FontType._();

  static const String defaultFont = 'Poppins';
  static const String defaultFontCN = 'HonorSansCN';
  static const String numbers = 'Lato';
}

class AppColor {
  AppColor._();
  static const Color backgroundColor = Color(0xFFF3F2F7);
  static const Color primaryColor = Color(0xFFE51C1C);
  static const Color secondaryColor = Color(0xFF985852);
  static const Color fontColor = Color(0xFF3C3C3C);

  static const Color divider = Color(0xFF000029);

  static const List<Color> loadingBarGradients = [
    Color(0xFFFFE141),
    Color(0xFFF3BB3C),
  ];

  static const List<Color> mainHeaderGradients = [
    Color(0xFFFF1F1F),
    Color(0xFF5E1B1B),
  ];
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
  static TextStyle getFont(int size,
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
