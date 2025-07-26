import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  final TextEditingController nameController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<Map<String, dynamic>> meds = [];
  final TextEditingController durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMeds();
  }

  Future<void> _loadMeds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString('medications');
    if (saved != null) {
      meds = List<Map<String, dynamic>>.from(json.decode(saved));
      setState(() {});
    }
  }

  Future<void> _saveMeds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('medications', json.encode(meds));
  }

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _addMed() {
    if (nameController.text.isEmpty || durationController.text.isEmpty) return;

    final now = DateTime.now();
    final entry = {
      'name': nameController.text,
      'hour': selectedTime.hour,
      'minute': selectedTime.minute,
      'duration': int.tryParse(durationController.text),
      'startDate': now.toIso8601String()
    };

    meds.add(entry);
    _saveMeds();

    nameController.clear();
    durationController.clear();
    setState(() {});
  }

  void _removeExpiredMeds() {
    final now = DateTime.now();
    meds.removeWhere((med) {
      final start = DateTime.parse(med['startDate']);
      final duration = med['duration'];
      return now.difference(start).inDays >= duration;
    });
    _saveMeds();
  }

  @override
  Widget build(BuildContext context) {
    _removeExpiredMeds();
    final themeColor = const Color(0xFFEDE7F6); // light violet

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Reminder'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: themeColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tablet Name'),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Time: ${selectedTime.format(context)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (days)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Add Reminder'),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const Text(
              'Saved Medications',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: meds.length,
              itemBuilder: (context, index) {
                final med = meds[index];
                final date = DateFormat('MMM d').format(DateTime.parse(med['startDate']));
                return ListTile(
                  title: Text("${med['name']} at ${med['hour']}:${med['minute'].toString().padLeft(2, '0')}"),
                  subtitle: Text('Started: $date | ${med['duration']} days'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        meds.removeAt(index);
                        _saveMeds();
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}