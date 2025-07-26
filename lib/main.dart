import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heart_flutter/heart_rate_page.dart';
import 'package:heart_flutter/welcome_page.dart';
import 'package:heart_flutter/personal_details_page.dart';
import 'package:heart_flutter/home_page.dart' as home;
import 'package:heart_flutter/quick_access_page.dart';
import 'package:heart_flutter/pages/emer_page.dart';
import 'package:heart_flutter/services/emer_ser.dart';
import 'package:heart_flutter/ac_remote_page.dart';
import 'package:heart_flutter/tv_remote_page.dart';
import 'package:heart_flutter/medication_page.dart';
import 'package:heart_flutter/sugar_page.dart';
import 'package:heart_flutter/profile_page.dart' as profile;

void main() {
  runApp(const SmartQuickAccessApp());
}

class SmartQuickAccessApp extends StatelessWidget {
  const SmartQuickAccessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Quick Access',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: const Color(0xFFF3F1FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6C63FF),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      home: const WelcomePage(),
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/personal_details': (context) => const PersonalDetailsPage(),
        '/home': (context) => const home.HomePage(),
        '/emergency': (context) => const EmergencyPage(),
        '/heart': (context) => const  HeartRateScreen(),
        '/quick_access': (context) => const QuickAccessPage(),
        '/ac_remote': (context) => const ACRemotePage(),
        '/tv_remote': (context) => const TVRemotePage(),
        '/medication': (context) => const MedicationPage(),
        '/sugar': (context) => const SugarPage(),
        '/profile': (context) => const profile.ProfilePage(),
      },
    );
  }
}
/*import 'package:flutter/material.dart';
import 'heart_rate.dart'; 

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
      home: HeartRateScreen(), 
    );
  }
}*/