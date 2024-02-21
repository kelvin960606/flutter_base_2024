import 'package:flutter/material.dart';
import 'package:flutter_base_2024/constants/styles.dart';
import 'package:flutter_base_2024/controllers/app_controller.dart';
import 'package:flutter_base_2024/utils/common.dart';
import 'package:get/get.dart';

class AppMainHeader extends StatefulWidget {
  final double height;
  const AppMainHeader({
    Key? key,
    this.height = 150,
  }) : super(key: key);

  @override
  State<AppMainHeader> createState() => _AppMainHeaderState();
}

class _AppMainHeaderState extends State<AppMainHeader> {
  final AppController appController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      // handle safe area
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, right: defaultPadding),
      width: double.infinity,
      height: widget.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColor.mainHeaderGradients,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: defaultPadding),
          // LOGO
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'LOGO',
              style: FontStyle.getFont(
                16,
                weight: FontWeight.w900,
              ).copyWith(
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          addWidthSpace(0.5),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image.asset(
              'lib/assets/images/search.png',
              width: 15,
              height: 15,
            ),
          ),
        ],
      ),
    );
  }
}
