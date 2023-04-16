import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm_example/screens/edit_alarm.dart';
import 'package:alarm_example/screens/ring.dart';
import 'package:alarm_example/screens/settings.dart';
import 'package:alarm_example/widgets/group_alarms.dart';
import 'package:alarm_example/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                ExampleAlarmEditScreen(alarmSettings: settings, group: false),
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo.shade500,
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
                          'Settings',
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
                          onPressed: () => navigateToAlarmScreen(null),
                        ),
                      ),
                    ]
                  : null,
        ),
        body: selectedIndex == 0
            ? SafeArea(
                child: alarms.isNotEmpty
                    ? ListView.separated(
                        itemCount: alarms.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.indigo,
                                  ),
                                  onPressed: () =>
                                      navigateToAlarmScreen(alarms[index]),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No alarms',
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
              )
            : selectedIndex == 1
                ? const GroupAlarms()
                : selectedIndex == 2
                    ? const Settings()
                    : null,
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.all(10),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       FloatingActionButton(
        //         onPressed: () {
        //           final alarmSettings = AlarmSettings(
        //             id: 42,
        //             dateTime: DateTime.now(),
        //             assetAudioPath: 'assets/mozart.mp3',
        //           );
        //           Alarm.set(alarmSettings: alarmSettings);
        //         },
        //         backgroundColor: Colors.red,
        //         heroTag: null,
        //         child: const Text("RING NOW", textAlign: TextAlign.center),
        //       ),
        //     ],
        //   ),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.indigo.shade500,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedPageIndex,
          onTap: (int index) {
            setState(() {
              selectedPageIndex = index;
            });
            selectedIndex = index;
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: 'Alarms',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              label: 'Groups',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ));
  }
}
