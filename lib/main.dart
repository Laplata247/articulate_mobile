import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';  // Import Landing Screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingScreen(),  // Show Landing Page first
    );
  }
}
