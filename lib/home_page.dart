import 'package:flutter/material.dart';
import 'package:heart_flutter/pages/emer_page.dart';
import 'package:heart_flutter/medication_page.dart';
import 'package:heart_flutter/heart_rate_page.dart';
import 'package:heart_flutter/sugar_page.dart';
import 'package:heart_flutter/heart_rate_page.dart';
import 'package:heart_flutter/chatbot_page.dart';
import 'package:heart_flutter/quick_access_page.dart';
import 'package:heart_flutter/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF9370DB),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  Widget _buildComponentCard({
    required BuildContext context,
    required String title,
    required String imagePath,
    required Widget navigateTo,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        color: const Color(0xFFE6E6FA),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Sharper edge
        ),
        child: Container(
          height: 130,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(), // UPPERCASE TITLE
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A0DAD),
                  ),
                ),
              ),
              Image.asset(
                'assets/$imagePath',
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildComponentCard(
              context: context,
              title: 'Emergency',
              imagePath: 'e.png',
              navigateTo: const EmergencyPage(),
            ),
            _buildComponentCard(
              context: context,
              title: 'Medication',
              imagePath: 'm.png',
              navigateTo: const MedicationPage(),
            ),
            _buildComponentCard(
              context: context,
              title: 'Sugar',
              imagePath: 's.png',
              navigateTo: const SugarPage(),
            ),
            _buildComponentCard(
              context: context,
              title: 'Heart',
              imagePath: 'h.png',
              navigateTo: const  HeartRateScreen(),
            ),
            _buildComponentCard(
              context: context,
              title: 'ChatBot',
              imagePath: 'c.png',
              navigateTo: const ChatBotPage(),
            ),
            _buildComponentCard(
              context: context,
              title: 'Quick Access',
              imagePath: 'q.png',
              navigateTo: const QuickAccessPage(),
            ),
          ],
        ),
      ),
    );
  }
}