import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puff_vpn/Controller/vpn_controller.dart';
import 'package:puff_vpn/Utils/helper_functions.dart';
import 'package:puff_vpn/View/Screens/Country%20List/widgets/no_data.dart';
import 'package:puff_vpn/View/Screens/Country%20List/widgets/server_tile.dart';
import 'package:puff_vpn/View/Screens/Home/widgets/shimmer_effect_tile.dart';
import 'package:puff_vpn/services/vpn_engine.dart';

class ServerList extends StatefulWidget {
  const ServerList({super.key});

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  final vpnController = Get.find<VpnController>();

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
        title: Text(
          "Server List",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await vpnController.hitApi();
                // await ApiServices.fetchApiData();
                // await ApiServices.hitApiWithDebugging(Constant.vpnUrl);
              },
              icon: const Icon(Icons.refresh_sharp)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (vpnController
                  .selectedVpnServer.value.openVpnConfigDataBase64.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Server",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    ServerTile(
                        isNetwirk: true,
                        countryFlag:
                            vpnController.selectedVpnServer.value.countryShort,
                        countryName:
                            vpnController.selectedVpnServer.value.countryLong,
                        downloadSpeed: HelperFunctions.formatBytes(
                            vpnController.selectedVpnServer.value.speed, 1),
                        numberOfUsers: vpnController
                            .selectedVpnServer.value.numVpnSessions,
                        selected: true),
                    const SizedBox(height: 10),
                    Divider(),
                    const SizedBox(height: 5),
                  ],
                ),
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!vpnController.isLoading.value)
                        Text(
                          "Total Server (${vpnController.vpnList.first.ip.isEmpty ? 0 : vpnController.vpnList.length})",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      if (!vpnController.isLoading.value)
                        const SizedBox(height: 10),
                    ],
                  )),
              vpnController.isLoading.value
                  ? Expanded(child: shimmerEffectTile())
                  : vpnController
                          .vpnList.first.openVpnConfigDataBase64.isNotEmpty
                      ? Expanded(
                          child: ListView.separated(
                              itemCount: vpnController.vpnList.length,
                              separatorBuilder: (_, i) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final data = vpnController.vpnList[index];
                                return Obx(() => InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () async {
                                        if (data ==
                                            vpnController.selectedVpnServer
                                                .value) return;
                                        if (vpnController.vpnState.value ==
                                            VpnEngine.vpnConnected) {
                                          HelperFunctions.showCustomDialog(
                                            titleText: "Switch Server?",
                                            deleteButtonText: "Switch",
                                            contentText:
                                                "You are currently connected to a server. Connecting to a new server will disconnect the current connection. Do you want to proceed?",
                                            onDelete: () async {
                                              vpnController.selectedVpnServer
                                                  .value = data;
                                              await vpnController.saveVpnServer(
                                                  vpnController
                                                      .selectedVpnServer.value);
                                              VpnEngine.stopVpn();
                                              vpnController.isLoadingWhenSelect
                                                  .value = true;
                                              Get.back();
                                              Get.back();
                                              Future.delayed(
                                                  Duration(seconds: 1),
                                                  () => vpnController
                                                      .connectToVPN());
                                            },
                                            onCancel: () => Get.back(),
                                          );
                                        } else if (vpnController
                                                    .vpnState.value ==
                                                VpnEngine.vpnConnecting ||
                                            vpnController.vpnState.value ==
                                                VpnEngine.vpnAuthenticating) {
                                          HelperFunctions.showCustomDialog(
                                            titleText: "Connection in Progress",
                                            deleteButtonText: "Switch",
                                            contentText:
                                                "A connection is already in progress. Switching to another server now will cancel the current connection attempt. Do you want to switch to the new server?",
                                            onDelete: () async {
                                              vpnController.selectedVpnServer
                                                  .value = data;
                                              await vpnController.saveVpnServer(
                                                  vpnController
                                                      .selectedVpnServer.value);
                                              VpnEngine.stopVpn();
                                              vpnController.isLoadingWhenSelect
                                                  .value = true;
                                              Get.back();
                                              Get.back();
                                              Future.delayed(
                                                  Duration(seconds: 2),
                                                  () => vpnController
                                                      .connectToVPN());
                                            },
                                            onCancel: () => Get.back(),
                                          );
                                        } else {
                                          vpnController
                                              .selectedVpnServer.value = data;
                                          await vpnController.saveVpnServer(
                                              vpnController
                                                  .selectedVpnServer.value);
                                          vpnController
                                              .isLoadingWhenSelect.value = true;
                                          Get.back();
                                          Future.delayed(
                                              Duration(seconds: 1),
                                              () =>
                                                  vpnController.connectToVPN());
                                        }
                                      },
                                      child: ServerTile(
                                          countryFlag: data.countryShort,
                                          countryName: data.countryLong,
                                          downloadSpeed:
                                              HelperFunctions.formatBytes(
                                                  data.speed, 1),
                                          numberOfUsers: data.numVpnSessions,
                                          selected: vpnController
                                                      .selectedVpnServer
                                                      .value
                                                      .ip
                                                      .trim() ==
                                                  data.ip.trim()
                                              ? true
                                              : false),
                                    ));
                              }),
                        )
                      : noDataFound(),
            ],
          ),
        ),
      ),
    );
  }
}
