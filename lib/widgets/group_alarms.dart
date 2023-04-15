import 'package:flutter/material.dart';

import '../screens/login.dart';

class GroupAlarms extends StatefulWidget {
  const GroupAlarms({super.key});

  @override
  State<GroupAlarms> createState() => _GroupAlarmsState();
}

class _GroupAlarmsState extends State<GroupAlarms> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: LoginPage(),
    );
  }
}
