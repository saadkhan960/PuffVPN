import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puff_vpn/View/Global%20Widgets/cache_flag_image.dart';

class SpeedDownUp extends StatelessWidget {
  const SpeedDownUp({
    super.key,
    required this.title,
    required this.icon,
    required this.speed,
    this.sideSpace = true,
    this.sideSpaceValue = 0,
    this.image = "",
    this.isImage = false,
  });
  final String title;
  final IconData icon;
  final String speed;
  final bool sideSpace;
  final double sideSpaceValue;
  final String image;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width / 3.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              isImage
                  ? CacheFlag(
                      countryFlag: image,
                      width: 30,
                      height: 20,
                    )
                  : Icon(icon),
              const SizedBox(width: 5),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 2),
          image == ""
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        speed,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sideSpaceValue,
                  )
                ])
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    speed,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
        ],
      ),
    );
  }
}
