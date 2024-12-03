import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puff_vpn/Utils/colors.dart';
import 'package:puff_vpn/View/Screens/Splash%20Screen/splash_services/splash_services.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.07,
          vertical: Get.height * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.1),
            Image.asset(
              "assets/logo/welcome.png",
              height: Get.height * 0.22,
              width: Get.width,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              textAlign: TextAlign.center,
              "Welcome To puffVPN",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .apply(color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
                child: Text(
              textAlign: TextAlign.center,
              "Secure your internet connection, browse anonymously, and access global content with PuffVPN. Protect your privacy with fast and reliable servers, anytime, anywhere.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .apply(color: Colors.white),
            )),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue1),
              onPressed: () async {
                await SplashServices.setFirstTimeToFalse();
              },
              child: FittedBox(
                child: Row(
                  children: [
                    Text(
                      "Get Started",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
