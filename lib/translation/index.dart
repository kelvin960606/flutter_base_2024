import 'package:flutter_base_2024/translation/en.dart';
import 'package:flutter_base_2024/translation/zh.dart';
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          ...en,
        },
        'zh_CN': {
          ...zh,
        }
      };
}
