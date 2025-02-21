import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _initializeNotification();
  }

  void _initializeNotification() {
    var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettings = InitializationSettings(android: androidInit);
    localNotifications.initialize(initSettings);
  }

  Future<void> _requestNotificationPermission() async {
    // Check if the platform is Android and version is 33 (Android 13) or higher
    if (Platform.isAndroid) {
      var status = await Permission.notification.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        // Request notification permission
        await Permission.notification.request();
      }
    }
  }

  Future showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
    );
    var generalNotificationDetails = NotificationDetails(android: androidDetails);
    await localNotifications.show(
      0, 
      'Test Notification', 
      'This is a test notification', 
      generalNotificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      backgroundColor: Colors.black,
      body:   Center(
      child: ElevatedButton(
        onPressed: showNotification,
        child: Text("Trigger Notification",
        style: TextStyle(color: Colors.tealAccent),),
        style: ElevatedButton.styleFrom(
          elevation: 3,
          shadowColor: Colors.tealAccent,
          backgroundColor: Color.fromARGB(255, 46, 46, 46)),
      ),
      )
    );
  }
}

