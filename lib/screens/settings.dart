import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage('https://picsum.photos/400'),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Manoj',
              style: TextStyle(fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}
