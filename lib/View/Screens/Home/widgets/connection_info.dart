import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puff_vpn/Controller/vpn_controller.dart';
import 'package:puff_vpn/View/Screens/Home/widgets/speed_down_up.dart';

class ConnectionInfo extends StatefulWidget {
  const ConnectionInfo({
    super.key,
  });

  @override
  State<ConnectionInfo> createState() => _ConnectionInfoState();
}

class _ConnectionInfoState extends State<ConnectionInfo> {
  final vpnController = Get.find<VpnController>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height / 5.9,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Obx(() => SpeedDownUp(
                    title: "Download",
                    icon: Icons.arrow_downward,
                    speed: vpnController.vpnStatus.value.byteIn == null
                        ? '0 kbps'
                        : vpnController.vpnStatus.value.byteIn == " "
                            ? '0 kbps'
                            : vpnController.vpnStatus.value.byteIn!,
                    sideSpace: false,
                  )),
              const SizedBox(height: 45),
              Obx(() {
                return vpnController
                        .selectedVpnServer.value.countryShort.isNotEmpty
                    ? SpeedDownUp(
                        title: "Country",
                        icon: Icons.arrow_downward,
                        isImage: true,
                        speed:
                            vpnController.selectedVpnServer.value.countryLong,
                        image:
                            vpnController.selectedVpnServer.value.countryShort,
                        sideSpace: true,
                      )
                    : SizedBox(
                        width: Get.width / 3.2,
                        height: Get.width / 8,
                        child: SingleChildScrollView(
                          child: Text(
                            textAlign: TextAlign.center,
                            "No country Selected",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ));
              })
            ],
          ),
          const SizedBox(width: 20),
          Container(
            width: 1,
            height: Get.height,
            color: Colors.grey,
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              Obx(() => SpeedDownUp(
                    title: "Upload",
                    icon: Icons.arrow_upward,
                    speed: vpnController.vpnStatus.value.byteOut == null
                        ? '0 kbps'
                        : vpnController.vpnStatus.value.byteOut == " "
                            ? '0 kbps'
                            : vpnController.vpnStatus.value.byteOut!,
                    sideSpace: false,
                  )),
              const SizedBox(height: 45),
              Obx(
                () => SpeedDownUp(
                  title: "Ping",
                  icon: Icons.speed_rounded,
                  speed:
                      "${vpnController.selectedVpnServer.value.ping.isEmpty ? 0 : vpnController.selectedVpnServer.value.ping} ms",
                  sideSpaceValue: 23,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
