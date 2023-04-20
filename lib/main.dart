import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home.dart';
import 'screens/login.dart';

import 'package:adaptive_theme/adaptive_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(showDebugLogs: true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Check if the user is already logged in
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // If the user is already logged in, redirect to home page
  Widget initialScreen = isLoggedIn ? const HomePage() : const LoginPage();

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({
    Key? key,
    required this.initialScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
            brightness: Brightness.light, primaryColor: Colors.indigo.shade500),
        dark: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.grey.shade800,
        ),
        initial: AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) => MaterialApp(
              debugShowCheckedModeBanner: true,
              title: 'Flutter Demo',
              theme: theme,
              darkTheme: darkTheme,
              home: initialScreen,
            ));
  }
}
