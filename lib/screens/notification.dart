import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifTestScreen extends StatefulWidget {
  const NotifTestScreen({Key? key}) : super(key: key);

  @override
  _NotifTestScreenState createState() => _NotifTestScreenState();
}

class _NotifTestScreenState extends State<NotifTestScreen> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  var initializationSettingsAndroid;
  var initializationSettings;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      color: Colors.red,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin!.show(0, 'Test Notification',
        'This is a test notification!', platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Future.delayed(const Duration(seconds: 10), () {
              _showNotification();
            });
          },
          child: Text('Show Notification in 10 seconds'),
        ),
      ),
    );
  }
}
