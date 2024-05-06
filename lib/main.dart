import 'dart:io';

import 'package:canvas_connect/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/models/LoginModel.dart';
=======

import 'package:canvas_connect/resource/theme.dart';
import 'package:canvas_connect/shared/http.dart';
import 'package:canvas_connect/shared/service.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  notificationService.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
      autoStartOnBoot: true,
      initialNotificationTitle: "Notification service",
      initialNotificationContent: "Fetching data periodically"),
    iosConfiguration: IosConfiguration());

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: LoginScreen()
    );
  }
}
