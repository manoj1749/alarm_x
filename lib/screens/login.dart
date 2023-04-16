// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:alarm_example/utils/auth.dart';
import 'package:alarm_example/utils/checknetwork.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alarm_example/utils/snackbar.dart';

import '../utils/animatedpage.dart';
import 'home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
              child: AnimatedWave(
            height: 100,
            speed: 1.0,
          )),
          onBottom(AnimatedWave(
            height: 250,
            speed: 1.1,
          )),
          onBottom(AnimatedWave(
            height: 300,
            speed: 1.2,
            offset: pi,
          )),
          onBottom(AnimatedWave(
            height: 400,
            speed: 1.3,
            offset: pi / 2,
          )),
          //const Positioned.fill(child: Center(child: FlutterLogo(size: 150))),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to the Alarm App',
                  style: TextStyle(
                      fontSize: 20,

                      //fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                    return const Color.fromARGB(255, 162, 157, 150);
                  })),
                  onPressed: () async {
                    final bool userConnection =
                        await CheckUserConnection().checkUserConnection();
                    if (userConnection) {
                      await Authentication.initializeFirebase();
                      User? user = await Authentication.signInWithGoogle(
                          context: context);
                      print('1');
                      print(user);
                      print('2');

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
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
                // ElevatedButton.icon(
                //   style: ButtonStyle(backgroundColor:
                //       MaterialStateProperty.resolveWith<Color?>(
                //           (Set<MaterialState> states) {
                //     return const Color.fromARGB(255, 162, 157, 150);
                //   })),
                //   onPressed: () async {
                //     final bool userConnection =
                //         await CheckUserConnection().checkUserConnection();
                //     if (userConnection) {
                //       await Authentication.initializeFirebase();
                //       await Authentication.signOut(context: context);
                //       print('1');
                //       print('signed Out');
                //       //print(user);
                //       print('2');
                //       Navigator.of(context).pushReplacement(
                //         MaterialPageRoute(
                //           builder: (context) => const HomePage(),
                //         ),
                //       );
                //     } else if (!userConnection) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         snackBars.customSnackBar(
                //           content: 'No internet connection',
                //         ),
                //       );
                //     } else {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         snackBars.customSnackBar(
                //           content: 'Something went wrong',
                //         ),
                //       );
                //     }
                //   },
                //   icon: const Icon(Icons.login),
                //   label: const Text('Sign Out'),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}
