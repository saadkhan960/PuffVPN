import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puff_vpn/Utils/Theme/custom_theme.dart';
import 'package:puff_vpn/View/Screens/Home/home_screen.dart';
import 'package:puff_vpn/View/Screens/Splash%20Screen/splash_screen.dart';
import 'package:puff_vpn/View/Screens/Splash%20Screen/splash_services/splash_services.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<bool> firstTimeCheck() async {
    return await SplashServices().checkFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PuffVPN',
      theme: CustomTheme.customTheme,
      home: FutureBuilder<bool>(
        future: firstTimeCheck(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (snapshot.hasData) {
            if (data == true) {
              return const SplashScreen();
            } else {
              return const HomeScreen();
            }
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
