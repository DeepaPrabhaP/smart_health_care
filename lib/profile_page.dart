import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController(); // in cm
  TextEditingController weightController = TextEditingController(); // in kg
  String selectedGender = '';
  bool isEditing = false;
  double? bmi;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('name') ?? '';
    ageController.text = prefs.getString('age') ?? '';
    heightController.text = prefs.getString('height') ?? '';
    weightController.text = prefs.getString('weight') ?? '';
    selectedGender = prefs.getString('gender') ?? '';

    calculateBMI(); // load BMI
    setState(() {});
  }

  Future<void> saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('age', ageController.text);
    await prefs.setString('height', heightController.text);
    await prefs.setString('weight', weightController.text);
    await prefs.setString('gender', selectedGender);
    calculateBMI();
    setState(() {
      isEditing = false;
    });
  }

  void calculateBMI() {
    double? height = double.tryParse(heightController.text);
    double? weight = double.tryParse(weightController.text);
    if (height != null && weight != null && height > 0) {
      double heightInMeters = height / 100;
      bmi = weight / (heightInMeters * heightInMeters);
    } else {
      bmi = null;
    }
  }

  Widget genderButton(String gender) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedGender == gender ? Colors.deepPurple : Colors.grey[300],
        foregroundColor: selectedGender == gender ? Colors.white : Colors.black,
      ),
      onPressed: isEditing
          ? () {
              setState(() {
                selectedGender = gender;
              });
            }
          : null,
      child: Text(gender),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              readOnly: !isEditing,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ageController,
              readOnly: !isEditing,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: heightController,
              readOnly: !isEditing,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: weightController,
              readOnly: !isEditing,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              onChanged: (_) {
                if (isEditing) {
                  calculateBMI();
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Male', 'Female', 'Other']
                  .map((g) => genderButton(g))
                  .toList(),
            ),
            const SizedBox(height: 20),
            if (bmi != null)
              Text(
                "Your BMI: ${bmi!.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 30),
            isEditing
                ? ElevatedButton(
                    onPressed: saveUserData,
                    child: const Text('Save'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: const Text('Edit'),
                  ),
          ],
        ),
      ),
    );
  }
}