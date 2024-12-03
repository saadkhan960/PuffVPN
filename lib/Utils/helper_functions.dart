import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puff_vpn/Utils/colors.dart';

class HelperFunctions {
  static void showSnackbar({
    String? title,
    required String message,
    Color color = Colors.redAccent,
    int duration = 2,
    Icon? icon,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: title != null
          ? Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : const SizedBox.shrink(),
      messageText: message != ""
          ? Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : const SizedBox.shrink(),
      backgroundColor: color,
      duration: Duration(seconds: duration),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
      ),
      borderRadius: 10,
      isDismissible: true,
      icon: icon,
    );
  }

  static void simpleAnimationNavigation({
    required Widget screen,
    int durationInMillisec = 400,
    Cubic animationCurve = Curves.easeIn,
  }) {
    Get.to(
      () => screen,
      transition: Transition.rightToLeft,
      duration: Duration(milliseconds: durationInMillisec),
      curve: animationCurve,
      fullscreenDialog: true,
    );
  }

  static void mostStrictAnimationNavigation(Widget screen) {
    Get.off(screen,
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeIn);
  }

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";

    const suffixes = ["Bps", "Kbps", "Mbps", "Gbps", "Tbps"];

    var i = (log(bytes) / log(1024)).floor();

    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static void showCustomDialog(
      {required String titleText,
      String? contentText,
      String deleteButtonText = "Delete",
      String cancelButtonText = "Cancel",
      required VoidCallback onDelete,
      VoidCallback? onCancel,
      Color backgroundColor = AppColors.backgroundDark,
      Color titleTextColor = Colors.white,
      Color contentTextColor = Colors.white,
      Color deleteButtonTextColor = Colors.white,
      bool clickOnBackgroundToRemove = false,
      bool showDelete = true}) {
    Get.dialog(
      AlertDialog(
        backgroundColor: backgroundColor,
        title: titleText.isNotEmpty
            ? Center(
                child: Text(
                  titleText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleTextColor,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        content: contentText != null
            ? Text(
                contentText,
                textAlign: TextAlign.center,
                style: TextStyle(color: contentTextColor),
              )
            : null,
        actions: [
          if (showDelete)
            TextButton(
              onPressed: onDelete,
              child: Text(
                deleteButtonText,
                style: TextStyle(color: deleteButtonTextColor),
              ),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onPressed: onCancel,
            child: Text(cancelButtonText),
          ),
        ],
        actionsAlignment: showDelete
            ? MainAxisAlignment.spaceAround
            : MainAxisAlignment.center,
      ),
      barrierDismissible: clickOnBackgroundToRemove,
    );
  }
}
