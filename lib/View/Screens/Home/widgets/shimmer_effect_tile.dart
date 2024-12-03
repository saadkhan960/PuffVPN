import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puff_vpn/View/Screens/Country%20List/widgets/server_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget shimmerEffectTile() {
  return Skeletonizer(
    effect: const ShimmerEffect(baseColor: Color.fromARGB(255, 138, 140, 145)),
    justifyMultiLineText: true,
    enableSwitchAnimation: true,
    ignoreContainers: true,
    enabled: true,
    child: SizedBox(
      height: Get.height,
      child: ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return const ServerTile(
              isNetwirk: false,
              countryFlag: 'assets/images/US.png',
              countryName: 'United Stdasdasdate',
              downloadSpeed: '77.7 Mbps',
              numberOfUsers: 13,
              selected: false);
        },
      ),
    ),
  );
}
