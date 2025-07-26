import 'package:flutter/material.dart';

class QuickAccessPage extends StatefulWidget {
  const QuickAccessPage({super.key});

  @override
  State<QuickAccessPage> createState() => _QuickAccessPageState();
}

class _QuickAccessPageState extends State<QuickAccessPage> {
  bool isFanOn = false;
  bool isLightOn = false;

  void toggleFan() {
    setState(() {
      isFanOn = !isFanOn;
      final status = isFanOn ? "Turning ON FAN" : "Turning OFF FAN";
      _showSnackBar(status);
    });
  }

  void toggleLight() {
    setState(() {
      isLightOn = !isLightOn;
      final status = isLightOn ? "Turning ON LIGHT" : "Turning OFF LIGHT";
      _showSnackBar(status);
    });
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightViolet = const Color(0xFFEDE7F6);
    final cardHeight = MediaQuery.of(context).size.height * 0.22;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick Access"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildControlCard(
              label: 'AC REMOTE',
              imageAsset: 'assets/ac.png',
              onTap: () => Navigator.pushNamed(context, '/ac_remote'),
              color: lightViolet,
              height: cardHeight,
            ),
            _buildControlCard(
              label: 'TV REMOTE',
              imageAsset: 'assets/tv.png',
              onTap: () => Navigator.pushNamed(context, '/tv_remote'),
              color: lightViolet,
              height: cardHeight,
            ),
            _buildControlCard(
              label: 'FAN',
              imageAsset: 'assets/fan.png',
              onTap: toggleFan,
              color: isFanOn ? Colors.blue.shade100 : lightViolet,
              height: cardHeight,
            ),
            _buildControlCard(
              label: 'LIGHT',
              imageAsset: 'assets/l.png',
              onTap: toggleLight,
              color: isLightOn ? Colors.orange.shade100 : lightViolet,
              height: cardHeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlCard({
    required String label,
    required String imageAsset,
    required VoidCallback onTap,
    required Color color,
    required double height,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: MaterialButton(
          color: color,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: height * 0.85,
                width: height * 0.85,
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}