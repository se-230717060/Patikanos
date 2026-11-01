import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patikanos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF171A1D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D7A68),
          brightness: Brightness.light,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
