import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationData
{
  final String title;
  final String body;

  const NotificationData(this.title, this.body);
}

class NotificationManager
{
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static int _notificationId = 0;

  NotificationManager._();

  static void init() async
  {
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher")
      ),
    );
  }

  static void showNotification(NotificationData notification) async
  {
    await _plugin.show(
      _notificationId++,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          /* TODO: Use separate channels for announcements, assignments and other events */
          "channel",
          "channel",
          importance: Importance.max,
          priority: Priority.high,
        )
      )
    );
  }
}
