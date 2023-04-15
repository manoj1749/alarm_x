// ignore_for_file: use_build_context_synchronously

import 'package:alarm_example/utils/auth.dart';
import 'package:alarm_example/utils/checknetwork.dart';
import 'package:flutter/material.dart';
import 'package:alarm_example/utils/snackbar.dart';

import 'home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Alarm App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final bool userConnection =
                    await CheckUserConnection().checkUserConnection();
                if (userConnection) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ExampleAlarmHomeScreen(),
                    ),
                  );
                } else if (!userConnection) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBars.customSnackBar(
                      content: 'No internet connection',
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBars.customSnackBar(
                      content: 'Something went wrong',
                    ),
                  );
                }
              },
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
