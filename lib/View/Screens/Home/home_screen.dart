import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puff_vpn/Controller/vpn_controller.dart';
import 'package:puff_vpn/Utils/helper_functions.dart';
import 'package:puff_vpn/View/Screens/Country%20List/server_list.dart';
import 'package:puff_vpn/View/Screens/Home/widgets/connection_info.dart';
import 'package:puff_vpn/View/Screens/Home/widgets/timer.dart';
import 'package:puff_vpn/services/vpn_engine.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late VpnController vpnController;

  @override
  void initState() {
    super.initState();
    vpnController = Get.put(VpnController());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      await VpnEngine.stopVpn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Puff VPN",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              HelperFunctions.simpleAnimationNavigation(
                  screen: const ServerList());
              if (vpnController.vpnList.isEmpty ||
                  vpnController.vpnList[0].ping == "") {
                await vpnController.hitApi();
              }
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                "assets/images/auto.png",
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => SizedBox(
                width: Get.width,
                height: Get.height / 3.5,
                child: vpnController.mainArtBoard.value != null
                    ? Rive(
                        artboard: vpnController.mainArtBoard.value!,
                        fit: BoxFit.contain,
                      )
                    : const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => SizedBox(
                  width: Get.width / 2.2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (vpnController.isLoadingWhenSelect.value == true) {
                        return;
                      } else {
                        if (vpnController.vpnState.value ==
                            VpnEngine.vpnConnected) {
                          HelperFunctions.showCustomDialog(
                            deleteButtonTextColor: Colors.redAccent,
                            titleText: "",
                            deleteButtonText: "Disconnet",
                            contentText: "Are you sure you want to disconnect?",
                            cancelButtonText: "No",
                            onDelete: () {
                              vpnController.connectToVPN();
                              Get.back();
                            },
                            onCancel: () => Get.back(),
                          );
                        } else {
                          vpnController.connectToVPN();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: vpnController.getButtonColor,
                        foregroundColor: Colors.white),
                    child: vpnController.isLoadingWhenSelect.value == true
                        ? Center(
                            child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(vpnController.getButtonText,
                                  style: const TextStyle(fontSize: 17)),
                              const SizedBox(width: 5),
                              const Icon(Icons.power_settings_new_outlined)
                            ],
                          ),
                  ),
                )),
            Obx(() => Column(children: [
                  const SizedBox(height: 10),
                  Text(
                    vpnController.getVpnStatusText.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ])),
            const SizedBox(height: 10),
            Obx(() => vpnController.elapsedTime.value != Duration.zero
                ? const TimerWidget()
                : const SizedBox.shrink()),
            const SizedBox(height: 40),
            const ConnectionInfo(),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
