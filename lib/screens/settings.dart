import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _setupNotifications(); // Call separate method
    
  }

  void _setupNotifications() async {
    if (Platform.isAndroid) {
  await Permission.notification.request();
}
    await _requestNotificationPermission();
    _initializeNotification();
    _createNotificationChannel();
    await _initializeTimeZone(); // Initialize time zone
  }

  Future<void> _initializeTimeZone() async {
    tz.initializeTimeZones(); // Initialize time zones
    try {
      String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      print("Current Time Zone: $currentTimeZone"); // Log the time zone

      // Handle the mismatch for "Asia/Calcutta"
      if (currentTimeZone == "Asia/Calcutta") {
        currentTimeZone = "Asia/Kolkata"; // Map to the correct IANA time zone
        print("Mapped Time Zone to: $currentTimeZone");
      }

      // Set the local time zone
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
      print("Local time zone set to: $currentTimeZone");

      // Verify the current local time
      final now = tz.TZDateTime.now(tz.local);
      print("Current Local Time After Setting Time Zone: $now");
    } catch (e) {
      print("Error setting time zone: $e");
      // Fallback to a known time zone (e.g., UTC)
      tz.setLocalLocation(tz.getLocation('UTC'));
      print("Fallback to UTC time zone");
    }
  }

  void _initializeNotification() {
    var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettings = InitializationSettings(android: androidInit);
    localNotifications.initialize(initSettings);
  }

  void _createNotificationChannel() async {
    const AndroidNotificationChannel channel =
     AndroidNotificationChannel(
      'channelId', // Same as in AndroidNotificationDetails
      'channelName', // Same as in AndroidNotificationDetails
      importance: Importance.max,
    );

    await localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.notification.status;
      if (status.isDenied || status.isPermanentlyDenied) {
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
    var generalNotificationDetails =
     NotificationDetails(android: androidDetails);
    await localNotifications.show(
      0, 
      'Instant Notification', 
      'This is an instant notification', 
      generalNotificationDetails,
    );
  }

  Future<void> _scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    print("Current Local Time: $now"); // Log current local time

    // For testing, manually set the date to today
    final today = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    print("Manually Set Date: $today");

    var scheduledDate = today;

    print("Scheduled Date Before Adjustment: $scheduledDate"); // Log scheduled date

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    print("Scheduled Date After Adjustment: $scheduledDate"); // Log adjusted scheduled date

    var androidDetails = AndroidNotificationDetails(
  'channelId',  // Make sure this matches the one in _createNotificationChannel()
  'channelName',
  importance: Importance.max,
  priority: Priority.high,
  playSound: true,
);

var generalNotificationDetails = NotificationDetails(android: androidDetails);

await localNotifications.zonedSchedule(
  id,
  title,
  body,
  scheduledDate,
  generalNotificationDetails,
  uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
  matchDateTimeComponents: DateTimeComponents.time,
);

    print("Notification Scheduled for $scheduledDate");
  }

  Future<void> cancelAllNotifications() async {
    await localNotifications.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: showNotification,
              child: Text(
                "Trigger Instant Notification",
                style: TextStyle(color: Colors.tealAccent),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                shadowColor: Colors.tealAccent,
                backgroundColor: Color.fromARGB(255, 46, 46, 46),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final now = tz.TZDateTime.now(tz.local);
                _scheduleNotification(
                  title: "web3dev",
                  body: "Hi from web3dev",
                  hour: now.hour,
                  minute: now.minute + 1, // Schedule for 1 minute later
                );
              },
              child: Text(
                "Schedule Notification",
                style: TextStyle(color: Colors.tealAccent),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                shadowColor: Colors.tealAccent,
                backgroundColor: Color.fromARGB(255, 46, 46, 46),
              ),
            ),
          ],
        ),
      ),
    );
  }
}