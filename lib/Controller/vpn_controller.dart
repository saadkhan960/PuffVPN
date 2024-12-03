import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puff_vpn/Model/vpn_config.dart';
import 'package:puff_vpn/Data/Network/api_service.dart';
import 'package:puff_vpn/Model/vpn_server_model.dart';
import 'package:puff_vpn/Model/vpn_status.dart';
import 'package:puff_vpn/Utils/colors.dart';
import 'package:puff_vpn/Utils/constant.dart';
import 'package:puff_vpn/Utils/helper_functions.dart';
import 'package:puff_vpn/View/Screens/Country%20List/server_list.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/vpn_engine.dart';

class VpnController extends GetxController {
// ------------VARIABLES------------------------------------------------------

  //Shared Pref
  late final SharedPreferences _prefs;
  //Rive Animation
  Rx<StateMachineController?> stateMachineController =
      Rx<StateMachineController?>(null);
  Rx<Artboard?> mainArtBoard = Rx<Artboard?>(null);
  Rx<SMIBool?> push = Rx<SMIBool?>(null);
  Rx<SMIBool?> valid = Rx<SMIBool?>(null);
  Rx<SMIBool?> error = Rx<SMIBool?>(null);

  //Button and Timer
  Rx<Duration> elapsedTime = Duration.zero.obs;
  Rx<Timer>? _timer = Timer(const Duration(), () {}).obs;

  //Vpn realted varaibles-------
  final RxBool isLoadingWhenSelect = false.obs;
  final RxList<VpnServer> vpnList = [VpnServer.empty()].obs;
  final Rx<VpnServer> selectedVpnServer = VpnServer.empty().obs;
  final RxBool isLoading = false.obs;
  // Observables for VPN state
  final vpnState = VpnEngine.vpnDisconnected.obs;
  Rx<VpnStatus> vpnStatus = VpnStatus().obs;

// ------------FUNCTIONS-----------------------------------------------------

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    await loadAnimation();
    // await requestNotificationPermission();
    await getVpnServer();
    await loadVpnServers();
    // Listen for VPN state changes to update animations
    VpnEngine.vpnStageSnapshot().listen((event) {
      vpnState.value = event;

      // if (event == VpnEngine.vpnConnecting ||
      //     event == VpnEngine.vpnAuthenticating) {
      //   push.value?.value = true;
      //   valid.value?.value = false;
      //   error.value?.value = false;
      // }
      if (event == VpnEngine.vpnConnected) {
        push.value?.value = true;
        valid.value?.value = true;
        error.value?.value = false;
        startTimer();
      } else if (event == VpnEngine.vpnDisconnected) {
        push.value?.value = false;
        valid.value?.value = false;
        error.value?.value = false;
        stopTimer();
      } else {
        push.value?.value = true;
        valid.value?.value = false;
        error.value?.value = false;
        // push.value?.value = true;
        // valid.value?.value = false;
        // error.value?.value = true;
      }
    });
    listenToVpnStatus();
  }

  @override
  void onClose() {
    _timer?.value.cancel();
    super.onClose();
  }

  // -----VPN RELATED STUFF------
  void listenToVpnStatus() {
    // Listen to the VPN status stream and update the Rx variable
    VpnEngine.vpnStatusSnapshot().listen((status) {
      if (status != null) {
        vpnStatus.value = status;
      }
    });
  }

  void connectToVPN() async {
    if (selectedVpnServer.value.openVpnConfigDataBase64.isEmpty) {
      print("empty eslss print");
      HelperFunctions.showCustomDialog(
          titleText: "",
          contentText: "Please select a server first to connect to the VPN",
          onDelete: () {},
          onCancel: () async {
            Get.back();
            HelperFunctions.simpleAnimationNavigation(
                screen: const ServerList());
            if (vpnList.isEmpty || vpnList[0].ping == "") {
              await hitApi();
            }
          },
          cancelButtonText: "Select",
          showDelete: false);
    }
    ;

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      isLoadingWhenSelect.value = false;
      final data = const Base64Decoder()
          .convert(selectedVpnServer.value.openVpnConfigDataBase64);
      final vpnConfig = VpnConfig(
        country: selectedVpnServer.value.countryLong,
        username: 'vpn',
        password: 'vpn',
        config: const Utf8Decoder().convert(data),
      );

      // Start if stage is disconnected
      await VpnEngine.startVpn(vpnConfig);
    } else {
      // Stop if stage is Connected
      await VpnEngine.stopVpn();
    }
  }

  // Future<void> requestNotificationPermission() async {
  //   bool granted = await Permission.notification.isGranted;
  //   if (!granted) {
  //     await Permission.notification.request();
  //   }
  // }

  //Hit api and add data on variable
  Future<void> hitApi() async {
    isLoading.value = true;
    vpnList.value = await ApiServices().getGetApiResponce(Constant.vpnUrl);
    isLoading.value = false;
  }

  //Timer
  void startTimer() {
    // Cancel any existing timer
    _timer?.value.cancel();

    // Reset elapsed time
    elapsedTime.value = Duration.zero;

    // Start a new timer
    _timer = Rx(Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedTime.value += const Duration(seconds: 1);

      // Stop the timer after 24 hours
      if (elapsedTime.value >= const Duration(hours: 24)) {
        timer.cancel();
        _timer?.value = Timer(const Duration(), () {});
      }
    }));
  }

  void stopTimer() {
    // Safely cancel and clear the timer
    if (_timer?.value != null && _timer!.value.isActive) {
      _timer!.value.cancel();
    }
    _timer?.value = Timer(const Duration(), () {});

    // Reset elapsed time to zero
    elapsedTime.value = Duration.zero;
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  //Rive Animation
  loadAnimation() async {
    await rootBundle.load("assets/rive/anim.riv").then((riveByteData) {
      var riveFile = RiveFile.import(riveByteData);
      var mArtBoard = riveFile.mainArtboard;
      var controller =
          StateMachineController.fromArtboard(mArtBoard, "quiz_machine");
      if (controller != null) {
        mArtBoard.addController(controller);
        mainArtBoard.value = mArtBoard;

        stateMachineController.value = controller;
        push.value = controller.findSMI("push");
        valid.value = controller.findSMI("valid");
        error.value = controller.findSMI("error");
      }
    });
  }

  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return AppColors.blue1;

      case VpnEngine.vpnConnected:
        return Colors.red;

      default:
        return Colors.orangeAccent;
    }
  }

  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Connect';

      case VpnEngine.vpnConnected:
        return 'Disconnect';

      default:
        return 'Stop';
    }
  }

  String get getVpnStatusText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Disconnected';

      case VpnEngine.vpnConnected:
        return 'Connected';

      case VpnEngine.vpnAuthenticating:
        return 'Authenticating...';
      case VpnEngine.vpnPrepare:
        return 'Prepering...';
      case VpnEngine.vpnWaitConnection:
        return 'Waiting...';
      case VpnEngine.vpnReconnect:
        return 'Reconnecting...';

      case VpnEngine.vpnConnecting:
        return 'Connecting...';
      default:
        return 'Connecting...';
    }
  }

  //Shared Prefrences---------------------
  //to save one selected server
  Future<void> saveVpnServer(VpnServer server) async {
    String jsonString = jsonEncode(server.toJson());
    await _prefs.setString('vpnServer', jsonString);
  }

// To get selected server
  Future<void> getVpnServer() async {
    String? jsonString = await _prefs.getString('vpnServer');
    if (jsonString != null) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      selectedVpnServer.value = VpnServer.fromJson(json);
    }
    return null;
  }

// To save the list of servers received from the API

  // Future<void> saveVpnServers(List<VpnServer> servers) async {
  //   // Convert the list of servers to a JSON string
  //   List<Map<String, dynamic>> jsonList =
  //       servers.map((server) => server.toJson()).toList();
  //   String jsonString = jsonEncode(jsonList);

  //   // Save the JSON string to shared preferences
  //   await _prefs.setString('vpnServers', jsonString);
  // }
  Future<void> saveVpnServers(List<VpnServer> servers) async {
    // Convert the list of servers to a JSON string
    List<Map<String, dynamic>> jsonList =
        servers.map((server) => server.toJson()).toList();
    String jsonString = jsonEncode(jsonList);

    // Save the JSON string to shared preferences
    bool isSaved = await _prefs.setString('vpnServers', jsonString);

    // Print confirmation
    if (isSaved) {
      print("Data saved successfully!");
    } else {
      print("Failed to save data.");
    }
  }

// To get the list of servers
  Future<void> loadVpnServers() async {
    // Retrieve the JSON string from shared preferences
    String? jsonString = _prefs.getString('vpnServers');

    // If the string exists, save in vpnlist rx varaible
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      vpnList.value = jsonList.map((json) => VpnServer.fromJson(json)).toList();
    }
  }
}
