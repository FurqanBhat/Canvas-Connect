import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:canvas_connect/shared/service.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
           ListTile(
            title: const Text("Notification refresh interval:"),
            trailing: DropdownMenu<Duration>(
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: Duration(seconds: 10), label: "10 seconds"),
                DropdownMenuEntry(value: Duration(minutes: 15), label: "15 minutes"),
                DropdownMenuEntry(value: Duration(minutes: 15), label: "30 minutes"),
                DropdownMenuEntry(value: Duration(hours: 1), label: "1 hour"),
                DropdownMenuEntry(value: Duration(hours: 2), label: "2 hours"),
                DropdownMenuEntry(value: Duration(hours: 3), label: "3 hours"),
              ],
              initialSelection: const Duration(seconds: 10),
              onSelected: (value) async {
                final SharedPreferences preferences = await SharedPreferences.getInstance();

                preferences.setInt("updateInterval", value!.inSeconds);

                /* Restart notification service to make change effective */
                restartService();
              },
            ),
          ),
          ListTile(
            title: const Text("Notifiy about approaching deadlines before:"),
            trailing: DropdownMenu<Duration>(
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: Duration(minutes: 30), label: "30 minutes"),
                DropdownMenuEntry(value: Duration(hours: 1), label: "1 hour"),
                DropdownMenuEntry(value: Duration(hours: 2), label: "2 hours"),
                DropdownMenuEntry(value: Duration(hours: 3), label: "3 hours"),
                DropdownMenuEntry(value: Duration(hours: 6), label: "6 hours"),
                DropdownMenuEntry(value: Duration(hours: 12), label: "12 hours"),
                DropdownMenuEntry(value: Duration(days: 1), label: "1 day"),
              ],
              initialSelection: const Duration(minutes: 30),
              onSelected: (value) async {
                final SharedPreferences preferences = await SharedPreferences.getInstance();

                preferences.setInt("notifyBeforeDuration", value!.inSeconds);

                /* Restart notification service to make change effective */
                restartService();
              },
            ),
          )
        ],
      ),
    );
  }
}
