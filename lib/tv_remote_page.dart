import 'package:flutter/material.dart';

class TVRemotePage extends StatefulWidget {
  const TVRemotePage({super.key});

  @override
  State<TVRemotePage> createState() => _TVRemotePageState();
}

class _TVRemotePageState extends State<TVRemotePage> {
  String lastPressed = "";

  void onPressed(String label) {
    setState(() {
      lastPressed = label;
    });
  }

  Widget buildButton(String label,
      {double width = 80, double height = 50, IconData? icon, Color? color, bool isPower = false}) {
    final bool selected = lastPressed == label;

    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () => onPressed(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPower
              ? Colors.red
              : (selected ? const Color(0xFFD6D0FF) : Colors.white),
          foregroundColor: Colors.black,
          minimumSize: isPower ? const Size(80, 80) : Size(width, height),
          elevation: 2,
          side: BorderSide(
              color: isPower ? Colors.red.shade700 : const Color(0xFF6C63FF),
              width: 1.5),
          shape: isPower
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
        ),
        child: isPower
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.power_settings_new, color: Colors.black),
                  const SizedBox(height: 4),
                  const Text(
                    'ON',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              )
            : Text(
                label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget buildRemoteLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildButton("Power", isPower: true),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton("Vol +"),
            buildButton("Chan +"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton("Vol -"),
            buildButton("Chan -"),
          ],
        ),
        buildButton("Mute", width: 180),
        buildButton("Menu", width: 180),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton("Up"),
            buildButton("Down"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton("Left"),
            buildButton("Right"),
          ],
        ),
        buildButton("OK", width: 180),
        const SizedBox(height: 10),
        for (int i = 1; i <= 9; i += 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton(i.toString()),
              buildButton((i + 1).toString()),
              buildButton((i + 2).toString()),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton("Back"),
            buildButton("0"),
            buildButton("Exit"),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TV Remote"),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5),
              ],
            ),
            child: buildRemoteLayout(),
          ),
        ),
      ),
    );
  }
}