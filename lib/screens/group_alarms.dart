import 'package:flutter/material.dart';

class GroupAlarm extends StatefulWidget {
  const GroupAlarm({super.key});

  @override
  State<GroupAlarm> createState() => _GroupAlarmState();
}

class _GroupAlarmState extends State<GroupAlarm> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No Group Alarm', style: TextStyle(fontSize: 28)),
    );
  }
}
