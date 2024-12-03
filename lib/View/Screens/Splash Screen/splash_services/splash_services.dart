import 'package:get/get.dart';
import 'package:puff_vpn/Utils/helper_functions.dart';
import 'package:puff_vpn/View/Screens/Home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashServices extends GetxController {
  Future<bool> checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> setFirstTimeToFalse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    HelperFunctions.mostStrictAnimationNavigation(const HomeScreen());
  }
}
