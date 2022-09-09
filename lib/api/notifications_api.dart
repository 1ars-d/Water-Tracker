import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init() async {
    const android = AndroidInitializationSettings("ic_skylight_notification");
    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings, onSelectNotification: (_) {});
  }

  static void showNotification({
    String? title,
    String? body,
  }) async {
    _notifications.show(
        1,
        title,
        body,
        const NotificationDetails(
            android: AndroidNotificationDetails("channel", "name",
                importance: Importance.max)));
  }
}
