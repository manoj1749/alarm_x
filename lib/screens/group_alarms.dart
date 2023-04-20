import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm_example/screens/ring.dart';
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
    // Firebase.initializeApp();
    // FirebaseFirestore db = FirebaseFirestore.instance;
    // CollectionReference alarm = db.collection('alarm');
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
                onPressed: () {},
                child: const Text('Add Alarm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
