import 'dart:io';

import 'package:canvas_connect/screen/course_screen.dart';
import 'package:canvas_connect/screen/help.dart';
import 'package:canvas_connect/screen/login_screen.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/models/LoginModel.dart';
import 'package:canvas_connect/resource/theme.dart';
import 'package:canvas_connect/screen/course_list.dart';
import 'package:canvas_connect/shared/notification_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int defaultUpdateInterval = 60 * 5; // 5 minutes

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final SharedPreferences preferences = await SharedPreferences.getInstance();
  DateTime lastUpdated = DateTime.now();
  int interval = defaultUpdateInterval;
  int? savedInterval = preferences.getInt("updateInterval");

  /* Get saved interval if found and save default interval otherwise */
  if (savedInterval == null) {
    preferences.setInt("updateInterval", interval);
  } else {
    interval = savedInterval;
  }

  NotificationManager.init();

  /* HTTP overrides for background isolate */
  HttpOverrides.global = MyHttpOverrides();

  /* Initialize static classes for background isolate */
  await LoginModel.loginstart();
  await CoursesModel.fetchCourses();

  /* Create timer to check for new events on a fixed interval */
  Timer.periodic(
    Duration(seconds: interval),
    (timer) async {
      /*
       * Create a notification for every announcement and assignment created within
       * the checking interval
       */
      for (Course course in CoursesModel.activeCourses) {
        /* Announcements */
        for (Announcement announcement in await course.getAnnouncements(since: lastUpdated)) {
          NotificationManager.showNotification(
            NotificationData(
              course.name, announcement.title
            )
          );
        }

        /* Announcements */
        for (Assignment assignment in await course.getAssignments()) {
          NotificationManager.showNotification(
            NotificationData(
              course.name, "New assignment created: ${assignment.name}"
            )
          );
        }
      }

      lastUpdated = DateTime.now();
    }
  );
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  final service = FlutterBackgroundService();

  WidgetsFlutterBinding.ensureInitialized();

  service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      autoStartOnBoot: true,
      initialNotificationTitle: "Foreground service",
      initialNotificationContent: "Fetching data periodically"
    ),
    iosConfiguration: IosConfiguration()
  );

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
class MyHttpOverrides extends HttpOverrides{
@override
HttpClient createHttpClient(SecurityContext? context){
  return super.createHttpClient(context)
    ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
}
}

