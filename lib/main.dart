import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm_example/screens/home.dart';
import 'package:alarm_example/utils/auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Authentication.initializeFirebase();
  await Alarm.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init(showDebugLogs: true);

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}
