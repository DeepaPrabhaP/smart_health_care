import 'package:flutter/material.dart';

class ACRemotePage extends StatefulWidget {
  const ACRemotePage({super.key});

  @override
  State<ACRemotePage> createState() => _ACRemotePageState();
}

class _ACRemotePageState extends State<ACRemotePage> {
  bool isOn = false;
  int temperature = 24;
  String activeMode = "";

  void togglePower() {
    setState(() => isOn = !isOn);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isOn ? "AC turned ON" : "AC turned OFF")),
    );
  }

  void increaseTemp() {
    if (isOn && temperature < 30) {
      setState(() => temperature++);
    }
  }

  void decreaseTemp() {
    if (isOn && temperature > 16) {
      setState(() => temperature--);
    }
  }

  void selectMode(String mode) {
    if (!isOn) return;
    setState(() => activeMode = mode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$mode mode activated")),
    );
  }

  Widget buildRoundPowerButton(String label, VoidCallback onPressed, Color color) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildButton(String label, VoidCallback onPressed, {bool highlight = false}) {
    bool isModeActive = highlight && activeMode == label;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 14),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isModeActive ? const Color(0xFFD9C7FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isModeActive ? Colors.deepPurple : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFFD),
      appBar: AppBar(
        title: const Text("AC Remote"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 340,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Temperature",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$temperature°C",
                  style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton("-", decreaseTemp),
                    buildButton("+", increaseTemp),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildRoundPowerButton("ON", () {
                      if (!isOn) togglePower();
                    }, Colors.green),
                    buildRoundPowerButton("OFF", () {
                      if (isOn) togglePower();
                    }, Colors.red),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    buildButton("Cool", () => selectMode("Cool"), highlight: true),
                    buildButton("Heat", () => selectMode("Heat"), highlight: true),
                    buildButton("Fan", () => selectMode("Fan"), highlight: true),
                    buildButton("Swing", () => selectMode("Swing"), highlight: true),
                    buildButton("Sleep", () => selectMode("Sleep"), highlight: true),
                    buildButton("Timer", () => selectMode("Timer"), highlight: true),
                    buildButton("Mode", () => selectMode("Mode"), highlight: true),
                    buildButton("Auto", () => selectMode("Auto"), highlight: true),
                    buildButton("Eco", () => selectMode("Eco"), highlight: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}