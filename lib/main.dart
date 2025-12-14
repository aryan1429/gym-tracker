import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_scaffold.dart';

void main() {
  runApp(const GymTrackerApp());
}

class GymTrackerApp extends StatelessWidget {
  const GymTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainScaffold(),
    );
  }-+
  31,m `QWERTYUIOP[]\7`
}
