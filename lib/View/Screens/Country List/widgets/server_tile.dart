import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puff_vpn/Utils/colors.dart';
import 'package:puff_vpn/View/Global%20Widgets/cache_flag_image.dart';

class ServerTile extends StatelessWidget {
  const ServerTile(
      {super.key,
      required this.countryFlag,
      required this.countryName,
      required this.downloadSpeed,
      required this.numberOfUsers,
      required this.selected,
      this.isNetwirk = true});
  final String countryFlag;
  final String countryName;
  final String downloadSpeed;
  final int numberOfUsers;
  final bool selected;
  final bool isNetwirk;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 7),
      decoration: BoxDecoration(
        color: selected ? AppColors.blue6 : null,
        border: selected ? Border.all(color: AppColors.blue2) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          !isNetwirk
              ? const SizedBox(
                  width: 50,
                  height: 30,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                )
              : CacheFlag(countryFlag: countryFlag),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    countryName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.speed_rounded,
                      size: 21,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      downloadSpeed,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .apply(color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "|",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .apply(color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Text(
                          '$numberOfUsers',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          CupertinoIcons.person_3,
                          size: 25,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          selected
              ? const Icon(Icons.radio_button_checked_sharp,
                  color: AppColors.blue1)
              : const Icon(Icons.radio_button_off, color: AppColors.lightGrey),
        ],
      ),
    );
  }
}
