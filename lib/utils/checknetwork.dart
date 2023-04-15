// ignore_for_file: non_constant_identifier_names

import 'dart:io';

class CheckUserConnection {
  bool ActiveConnection = false;
  String T = "";

  CheckUserConnection();

  Future<bool> checkUserConnection() async {
    print("Checking User Connection");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        ActiveConnection = true;
        print(ActiveConnection);
      }
    } on SocketException catch (_) {
      ActiveConnection = false;
      print(ActiveConnection);
    }
    return ActiveConnection;
  }
}
