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

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: _isLoggedIn ? HomePage() : LoginPage(),
  ));
}
