import 'package:flutter/material.dart';
import 'heart_rate.dart'; // Import the file where HeartRateScreen is defined

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Heart Rate App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HeartRateScreen(), // Launching the screen
    );
  }
}
