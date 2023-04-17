import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm_example/screens/ring.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'edit_alarm.dart';
import 'home.dart';

class GroupAlarm extends StatefulWidget {
  const GroupAlarm({super.key});

  @override
  State<GroupAlarm> createState() => _GroupAlarmState();
}

class _GroupAlarmState extends State<GroupAlarm> {
  late List<AlarmSettings> alarms;
  TextEditingController _currentKeyController = TextEditingController();

  @override
  void dispose() {
    _currentKeyController.dispose();
    super.dispose();
  }

  Future<void> navigateToAlarMScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.6,
            child: ExampleAlarmEditScreen(
              alarmSettings: settings,
              group: true,
            ),
          );
        });

    //if (res != null && res == true) loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference alarm = db.collection('alarm');
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _currentKeyController,
                  decoration: const InputDecoration(
                    hintText: "Enter current key",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo),
                    ),
                  ),
                  cursorColor: Colors.indigo, //
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  final alarm =
                      db.collection('alarm').doc(_currentKeyController.text);
                  alarm.get().then(
                    (DocumentSnapshot doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      print(data);
                      print(data['dateTime'].seconds);
                      int timestampMilliseconds =
                          data['dateTime'].seconds * 1000;
                      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                          timestampMilliseconds);
                      print(dateTime.toString());

                      // DateTime tsdate =
                      //     DateTime.fromMillisecondsSinceEpoch(data['dateTime']);
                      // String datetime = tsdate.year.toString() +
                      //     "/" +
                      //     tsdate.month.toString() +
                      //     "/" +
                      //     tsdate.day.toString();
                      // print(datetime);
                      final date = dateTime;
                      final loopAudio = data['loopAudio'];
                      final vibrate = data['vibrate'];
                      final notificationTitle = data['notificationTitle'];
                      final notificationBody = data['notificationBody'];
                      final assetAudio = data['assetAudio'];
                      final alarmSettings = AlarmSettings(
                        id: 1,
                        dateTime: date,
                        loopAudio: loopAudio,
                        vibrate: vibrate,
                        notificationTitle: notificationTitle,
                        notificationBody: notificationBody,
                        assetAudioPath: assetAudio,
                      );
                      // void saveAlarm() {
                      //   Alarm.set(alarmSettings: alarmSettings)
                      //       .then((_) => Navigator.pop(context, true));
                      // }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExampleAlarmRingScreen(
                                alarmSettings: alarmSettings),
                          ));

                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => ExampleAlarmEditScreen(
                      //       alarmSettings: alarmSettings,
                      //       group: false,
                      //     ),
                      //   ),
                      // );
                      // ExampleAlarmEditScreen(
                      //     alarmSettings: alarmSettings, group: false);
                      // Alarm.setAlarm(
                      //   alarmSettings: alarmSettings,
                      //   onAlarm: (alarm) {
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) => RingScreen(
                      //           alarmSettings: alarmSettings,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
                    },
                    onError: (e) => print("Error getting document: $e"),
                  );
                  // handle copying and entering keys
                  // AlarmSettings alarmSettings = AlarmSettings(
                  // id: 1,
                  // dateTime: data['dateTime'],
                  // loopAudio: (data['loopAudio']),
                  // vibrate: data['vibrate'],
                  // notificationTitle: data['notificationTitle'],
                  // notificationBody: data['notificationBody'],
                  // assetAudioPath: data['assetAudio'],
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                  onPrimary: Colors.white,
                ),
                child: Text("Copy and Enter Keys"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
