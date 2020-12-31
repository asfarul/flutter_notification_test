import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() {
  _configureLocalTimeZone();
  runApp(MyApp());
}

void _configureLocalTimeZone() {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        if (payload != null) {
          debugPrint('notification payload : $payload');
        }
        return null;
      },
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _scheduleAlarm(DateTime scheduledNotificationDateTime) async {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          '001', 'testingFlutterNotif', 'Cuma testing',
          enableVibration: true,
          importance: Importance.max,
          priority: Priority.high);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Office',
          'Good morning! Time for office.',
          scheduledNotificationDateTime,
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);
    }

// Method 2
    Future _showNotificationWithDefaultSound() async {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          '001', 'testingFlutterNotif', 'Cuma testing',
          enableVibration: true,
          importance: Importance.max,
          priority: Priority.high);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'New Post',
        'How to Show Notification in Flutter',
        platformChannelSpecifics,
        payload: 'Default_Sound',
      );
    }

// Method 3
    Future _showNotificationWithoutSound() async {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          '001', 'testingFlutterNotif', 'Cuma testing',
          playSound: false,
          importance: Importance.max,
          priority: Priority.high);
      var iOSPlatformChannelSpecifics =
          new IOSNotificationDetails(presentSound: false);
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'New Post',
        'How to Show Notification in Flutter',
        platformChannelSpecifics,
        payload: 'No_Sound',
      );
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('tes local notif'),
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _scheduleAlarm(
                    tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)));
              },
              child: new Text('Show Schedule Notification (5 seconds)'),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              onPressed: _showNotificationWithoutSound,
              child: new Text('Show Notification Without Sound'),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              onPressed: _showNotificationWithDefaultSound,
              child: new Text('Show Notification With Default Sound'),
            ),
          ],
        ),
      ),
    );
  }
}
