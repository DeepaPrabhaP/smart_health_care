import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class SugarPage extends StatefulWidget {
  const SugarPage({super.key});

  @override
  State<SugarPage> createState() => _SugarPageState();
}

class _SugarPageState extends State<SugarPage> {
  final TextEditingController fastingController = TextEditingController();
  final TextEditingController postMealController = TextEditingController();
  List<Map<String, dynamic>> history = [];
  bool showAll = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('sugar_history');
    if (data != null) {
      setState(() {
        history = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sugar_history', json.encode(history));
  }

  void _addReading() {
    if (fastingController.text.isEmpty || postMealController.text.isEmpty) return;

    final double fasting = double.tryParse(fastingController.text) ?? 0;
    final double postMeal = double.tryParse(postMealController.text) ?? 0;
    final double combined = (fasting + postMeal) / 2;

    String feedback = combined < 100
        ? "Low Sugar"
        : combined <= 140
            ? "Normal"
            : "High Sugar";

    String advice = combined < 100
        ? "Your sugar is low. Please eat something sugary and consult a doctor."
        : combined <= 140
            ? "Sugar level is normal. Keep maintaining a healthy diet."
            : "Your sugar is high. Avoid sweets and consider medical advice.";

    final Map<String, dynamic> entry = {
      "date": DateTime.now().toString(),
      "fasting": fasting,
      "postMeal": postMeal,
      "combined": combined,
      "feedback": feedback,
      "advice": advice,
    };

    setState(() {
      history.insert(0, entry);
    });

    _saveHistory();
    fastingController.clear();
    postMealController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final latest = showAll ? history : history.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sugar Monitor"),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: fastingController,
              decoration: const InputDecoration(labelText: "Fasting Sugar"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: postMealController,
              decoration: const InputDecoration(labelText: "Post-meal Sugar"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addReading,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
              child: const Text("Check"),
            ),
            const SizedBox(height: 20),
            const Text("Recent History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...latest.map((e) => Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(
                  "Combined: ${e['combined'].toStringAsFixed(1)} - ${e['feedback']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Fasting: ${e['fasting']} | PostMeal: ${e['postMeal']}\n"
                  "${DateFormat.yMMMd().add_jm().format(DateTime.parse(e['date']).toLocal())}\n\n"
                  "🩺 Advice: ${e['advice']}",
                  style: const TextStyle(height: 1.4),
                ),
              ),
            )),
            if (history.length > 3)
              TextButton(
                onPressed: () => setState(() => showAll = !showAll),
                child: Text(showAll ? "Show Less" : "View All"),
              ),
          ],
        ),
      ),
    );
  }
}