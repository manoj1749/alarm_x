import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm_example/screens/home.dart';
import 'package:alarm_example/screens/login.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Authentication.initializeFirebase();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool _isLoggedIn = prefs.getBool('isLogged') ?? false;
  await Alarm.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Alarm.init(showDebugLogs: true);
  print(_isLoggedIn);

  runApp(MyApp(
    isLoggedin: _isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedin;
  MyApp({
    super.key,
    required this.isLoggedin,
  });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedin ? HomePage() : LoginPage(),
    );
  }
}
