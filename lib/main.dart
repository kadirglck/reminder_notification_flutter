import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notificationss/notificationHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);
  requestIOSPermissions(flutterLocalNotificationsPlugin);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  _showTimeDialog();
                },
                child: Text("Send not")),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  DateTime customNotificationTime;
  _showTimeDialog() async {
    DateTime picked = DateTime.now();
    // final DateTime picked = await showDatePicker(
    //   context: context,
    //   helpText: 'Doğum Tarihiniz',
    //   initialDate: selectedDate,
    //   firstDate: DateTime(1930),
    //   lastDate: DateTime(2025),
    // );
    TimeOfDay selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    // TimeOfDay selectedTime =
    //     TimeOfDay.fromDateTime(DateTime.parse('2018-10-20 16:30:04Z'));

    setState(() {
      customNotificationTime = DateTime(picked.year, picked.month, picked.day,
          selectedTime.hour, selectedTime.minute);
    });

    _configureCustomReminder(true);
  }

  void _configureCustomReminder(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);
    if (customNotificationTime != null) {
      var now = new DateTime.now();
      var notificationTime = new DateTime(
          customNotificationTime.year,
          customNotificationTime.month,
          customNotificationTime.day,
          customNotificationTime.hour,
          customNotificationTime.minute);

      scheduleNotification(flutterLocalNotificationsPlugin, counter, "Bodyyyy",
          notificationTime);
    }
  }
}
