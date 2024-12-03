import 'dart:async';
import 'package:flutter/material.dart';
import 'package:puff_vpn/my_app.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
// Initializes Flutter bindings.
  WidgetsFlutterBinding.ensureInitialized();

// Sets up local storage.
  await SharedPreferences.getInstance();

// Initializes Rive animations.
  unawaited(RiveFile.initialize());
  await Future.delayed(const Duration(milliseconds: 300));
  runApp(
    const MyApp(),
  );
}
// Developed by Muhammad Saad Khan
// Email: sk0663812@gmail.com
// LinkedIn: /saadkhan960
// GitHub: /saadkhan960
