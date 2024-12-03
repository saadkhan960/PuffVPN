import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puff_vpn/Utils/Theme/text_theme.dart';
import 'package:puff_vpn/Utils/colors.dart';

class CustomTheme {
  static ThemeData customTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundDark,
    useMaterial3: true,
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.blue1,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Poppins',
    textTheme: PTextTheme.textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.backgroundDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
  );
}
