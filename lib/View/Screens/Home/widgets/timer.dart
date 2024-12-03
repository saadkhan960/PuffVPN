import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puff_vpn/Controller/vpn_controller.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final VpnController controller = Get.find<VpnController>();

    return Obx(
      () => Text(
        controller.formatDuration(controller.elapsedTime.value),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
