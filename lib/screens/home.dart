import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm_example/screens/edit_alarm.dart';
import 'package:alarm_example/screens/ring.dart';
import 'package:alarm_example/screens/settings.dart';
import 'package:alarm_example/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'group_alarms.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<AlarmSettings> alarms;
  int selectedPageIndex = 0;

  static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();

      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> deleteAlarm(index) async {
    Alarm.stop(alarms[index].id);
    setState(() {
      alarms.removeAt(index);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExampleAlarmRingScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.6,
            child:
                ExampleAlarmEditScreen(alarmSettings: settings, group: !true),
          );
        });

    if (res != null && res == true) loadAlarms();
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

    if (res != null && res == true) loadAlarms();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  int selectedIndex = 0;

  Widget build(BuildContext context) {
    String mode = (AdaptiveTheme.of(context).mode).toString().substring(18);
    debugPrint(mode);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: selectedPageIndex == 0
              ? const Text(
                  'Alarm X',
                  style: TextStyle(fontSize: 28),
                )
              : selectedPageIndex == 1
                  ? const Text(
                      'Group Alarms',
                      style: TextStyle(fontSize: 28),
                    )
                  : selectedPageIndex == 2
                      ? const Text(
                          'Profile settings',
                          style: TextStyle(fontSize: 28),
                        )
                      : null,
          actions: selectedPageIndex == 0
              ? <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, right: 10),
                    child: IconButton(
                      icon: const Icon(Icons.alarm_add_outlined, size: 33),
                      onPressed: () => navigateToAlarmScreen(null),
                    ),
                  ),
                ]
              : selectedPageIndex == 1
                  ? <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, right: 10),
                        child: IconButton(
                          icon: const Icon(Icons.alarm_add_outlined, size: 33),
                          onPressed: () => navigateToAlarMScreen(null),
                        ),
                      ),
                    ]
                  : null,
        ),
        body: selectedIndex == 0
            ? SafeArea(
                child: alarms.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListView.separated(
                          itemCount: alarms.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return Container(
                              height: 100,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).secondaryHeaderColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        TimeOfDay(
                                          hour: alarms[index].dateTime.hour,
                                          minute: alarms[index].dateTime.minute,
                                        ).format(context),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 210),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.info_outline,
                                          color: (mode == 'dark')
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        onPressed: () => {
                                              debugPrint(
                                                  alarms[index].toString()),
                                              navigateToAlarmScreen(
                                                  alarms[index]),
                                            }),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      var dialog = showOkCancelAlertDialog(
                                        context: context,
                                        title: 'Delete Alarm',
                                        message:
                                            'Are you sure you want to delete this alarm?',
                                        isDestructiveAction: true,
                                      );
                                      print(dialog.toString());
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No alarms',
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
              )
            : selectedIndex == 1
                ? const GroupAlarm()
                : selectedIndex == 2
                    ? const Settings()
                    : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedPageIndex,
          onTap: (int index) {
            setState(() {
              selectedPageIndex = index;
            });
            selectedIndex = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: 'Alarms',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              label: 'Groups',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Profile',
            ),
          ],
        ));
  }
}
