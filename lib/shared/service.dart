import 'dart:io';
import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/models/LoginModel.dart';
import 'package:canvas_connect/shared/http.dart';
import 'package:canvas_connect/shared/notification_manager.dart';

final FlutterBackgroundService notificationService = FlutterBackgroundService();

/* Default notification settings */
const int defaultUpdateInterval = 10; // Short interval for testing
int defaultNotifyBeforeDuration = const Duration(days: 1).inSeconds;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final SharedPreferences preferences = await SharedPreferences.getInstance();
  DateTime lastUpdated = DateTime.now();
  int interval = defaultUpdateInterval;
  int notifyBeforeDuration = defaultNotifyBeforeDuration;
  int? savedInterval = preferences.getInt("updateInterval");
  int? savedNotifyBeforeDuration = preferences.getInt("notifyBeforeDuration");

  /* Get saved settings if found and save defaults otherwise */
  if (savedInterval == null) {
    preferences.setInt("updateInterval", interval);
  } else {
    interval = savedInterval;
  }

  if (savedNotifyBeforeDuration == null) {
    preferences.setInt("notifyBeforeDuration", notifyBeforeDuration);
  } else {
    notifyBeforeDuration = savedNotifyBeforeDuration;
  }

  service.on("stop").listen((event) { service.stopSelf(); });

  NotificationManager.init();

  /* HTTP overrides for background isolate */
  HttpOverrides.global = MyHttpOverrides();

  /* Initialize static classes for background isolate */
  await LoginModel.loginstart();
  await CoursesModel.fetchCourses();

  /* Create timer to check for new events on a fixed interval */
  Timer.periodic(Duration(seconds: interval), (timer) async {
    /*
       * Create a notification for every announcement and assignment created within
       * the checking interval
       */
    for (Course course in CoursesModel.activeCourses) {
      /* Announcements */
      for (Announcement announcement
          in await course.getAnnouncements(since: lastUpdated)) {
        NotificationManager.showNotification(
            NotificationData(course.name, announcement.title));
      }

      /* Assignments */
      for (Assignment assignment
          in await course.getAssignments(since: lastUpdated)) {
        NotificationManager.showNotification(NotificationData(
            course.name, "New assignment created: ${assignment.name}"));
      }

      /* Approaching assignment deadlines */
      for (Assignment assignment in await course.getAssignments(
          /*
           * Get assignments that are due a day from now, within a window that is
           * update interval wide.
           */
          dueBefore: lastUpdated.add(Duration(seconds: notifyBeforeDuration)),
          dueAfter: lastUpdated.add(Duration(seconds: notifyBeforeDuration))
                               .subtract(Duration(seconds: interval))
      )) {
        NotificationManager.showNotification(NotificationData(
            course.name, "Assignment due soon: ${assignment.name}"));
      }
    }

    lastUpdated = DateTime.now();
  });
}

void restartService() async {
  notificationService.invoke("stop");

  /* Wait for service to stop */
  await Future.doWhile(() {return notificationService.isRunning();});

  /* Start service */
  notificationService.startService();
}
