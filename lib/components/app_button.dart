import 'package:flutter/material.dart';
import 'package:flutter_base_2024/constants/styles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final Function? onPressed;
  final int radius;
  final Color? bgColor;
  final Color? fontColor;
  final Color? borderColor;
  final int fontSize;
  final double height;
  const AppButton({
    Key? key,
    required this.label,
    this.isLoading = false,
    this.onPressed,
    this.radius = 100,
    this.bgColor,
    this.fontColor,
    this.borderColor,
    this.fontSize = 14,
    this.height = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: ElevatedButton.styleFrom(
          primary: bgColor ?? AppColor.primaryColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor ?? AppColor.divider,
              width: 0.1,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: isLoading
            ? SpinKitThreeBounce(
                color: fontColor ?? AppColor.fontColor,
                size: fontSize.toDouble(),
              )
            : Text(
                label,
                style: FontStyle.getFont(fontSize).copyWith(
                  color: fontColor ?? AppColor.fontColor,
                ),
              ),
      ),
    );
  }
}
