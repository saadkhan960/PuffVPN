import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget noDataFound() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: Get.height / 4,
        width: Get.width,
        child: Image.asset(
          "assets/images/no-data.png",
          color: Colors.white,
        ),
      ),
      Text(
        "No Server",
        style: Theme.of(Get.context!).textTheme.headlineMedium,
      )
    ],
  );
}
