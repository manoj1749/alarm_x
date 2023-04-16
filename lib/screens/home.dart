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
            child: ExampleAlarmEditScreen(alarmSettings: settings),
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
        title: const Text(
          'Alarm X',
          style: TextStyle(fontSize: 28),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 10),
            child: IconButton(
              icon: const Icon(Icons.alarm_add_outlined, size: 33),
              onPressed: () => navigateToAlarmScreen(null),
            ),
          ),
        ],
      ),
      body: selectedIndex == 0
          ? SafeArea(
              child: alarms.isNotEmpty
                  ? ListView.separated(
                      itemCount: alarms.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return ExampleAlarmTile(
                          key: Key(alarms[index].id.toString()),
                          title: TimeOfDay(
                            hour: alarms[index].dateTime.hour,
                            minute: alarms[index].dateTime.minute,
                          ).format(context),
                          onPressed: () => navigateToAlarmScreen(alarms[index]),
                          onDismissed: () {
                            Alarm.stop(alarms[index].id)
                                .then((_) => loadAlarms());
                          },
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                final alarmSettings = AlarmSettings(
                  id: 42,
                  dateTime: DateTime.now(),
                  assetAudioPath: 'assets/mozart.mp3',
                );
                Alarm.set(alarmSettings: alarmSettings);
              },
              backgroundColor: Colors.red,
              heroTag: null,
              child: const Text("RING NOW", textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.indigo.shade500,

          //labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          //backgroundColor: Colors.indigo.shade500,
          selectedIndex: selectedPageIndex,
          onDestinationSelected: (int index) {
            // debugPrint("Selected index: $index");
            setState(() {
              selectedPageIndex = index;
            });
            selectedIndex = index;
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.alarm,
                color: Colors.white,
              ),
              label: 'Alarms',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.people_alt_outlined,
                color: Colors.white,
              ),
              label: 'Groups',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: 'Settings',
            ),
          ]),
    );
  }
}
