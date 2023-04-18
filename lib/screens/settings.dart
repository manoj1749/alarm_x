import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage('assets/images/pic.jpeg'),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Manoj',
              style: TextStyle(fontSize: 25),
            ),
          ),
          TextButton(
              onPressed: () async {
                AdaptiveTheme.of(context).toggleThemeMode();
                var theme = await AdaptiveTheme.getThemeMode();
                debugPrint(theme.toString());
              },
              child: Text(
                  'Change to ${AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark ? 'Light' : 'Dark'} Mode'))
        ],
      ),
    );
  }
}
