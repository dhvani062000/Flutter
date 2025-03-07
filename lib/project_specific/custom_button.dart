import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/constant/color_constant.dart';
import 'package:task/project_specific/text_theme.dart';


class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double borderRadius;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = ColorConstant.primary,
    this.borderRadius = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onPressed,
      child: Container(
        height: 60,
        width: Get.width,
        child: Center(
          child: Text(
            text,
            style: AppTextTheme.bold.copyWith(color: ColorConstant.whiteColor),
          ),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}