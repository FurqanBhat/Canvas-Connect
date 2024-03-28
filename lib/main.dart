import 'package:canvas_connect/screen/help.dart';
import 'package:canvas_connect/screen/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:canvas_connect/resource/theme.dart';
import 'package:canvas_connect/screen/course_list.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: LoginScreen()
    );
  }
}
