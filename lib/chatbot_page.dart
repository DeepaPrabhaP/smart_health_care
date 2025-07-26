import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> chatMessages = [];
  String userName = "User";

  @override
  void initState() {
    super.initState();
    _fetchName();
  }

  Future<void> _fetchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? "User";
    });
  }

  void _handleSend(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      chatMessages.add({"sender": userName, "text": message});
    });

    _controller.clear();
    _respondToUser(message);
  }

  void _respondToUser(String message) {
    String response = "Sorry, I didn't understand that. Try asking your health related queries.";
    message = message.toLowerCase();

    if (message.contains("hi") || message.contains("hello")) {
      response = "Hello $userName! How can I assist your health today?";
    } else if (message.contains("sugar")) {
      response = "You can monitor and view sugar graphs on the Sugar page.";
    } else if (message.contains("medicine") || message.contains("reminder")) {
      response = "Go to Medication page to add tablets and get reminder alerts.";
    } else if (message.contains("heart")) {
      response = "You can check your heart rate in the Heart Rate Monitoring page.";
    } else if (message.contains("emergency")) {
      response = "Tap the Emergency page to contact saved emergency contacts quickly.";
    } else if (message.contains("ac remote")) {
      response = "Use the AC Remote page to control your air conditioner.";
    } else if (message.contains("tv remote")) {
      response = "TV Remote is available in Quick Access. You can use it like your normal remote.";
    } else if (message.contains("profile")) {
      response = "Go to Profile from the bottom icon to view or edit saved user details.";
    } else if (message.contains("chatbot")) {
      response = "Yes! I'm your health assistant bot 😊 Ask anything health-related.";
    } else if (message.contains("not feeling well") || message.contains("sick")) {
      response = "Take some rest, stay hydrated. Want to tell me your symptoms?";
    } else if (message.contains("cold")) {
      response = "Drink warm liquids, wear warm clothes. If it gets worse, consult a doctor.";
    } else if (message.contains("cough")) {
      response = "Try warm water with honey. If it’s dry and lasts long, visit a doctor.";
    } else if (message.contains("vomiting")) {
      response = "Stay hydrated. ORS is recommended. Visit doctor if continues.";
    } else if (message.contains("diarrhea")) {
      response = "ORS, soft food and hygiene are key. See doctor if it's frequent.";
    } else if (message.contains("headache")) {
      response = "Rest in a calm space, drink water. Persistent? Meet a doctor.";
    } else if (message.contains("hydration") || message.contains("water")) {
      response = "Drink 8-10 glasses of water daily to stay healthy!";
    } else if (message.contains("sleep")) {
      response = "Sleep 7-8 hours. Use blue light filter before bed.";
    } else if (message.contains("fatigue") || message.contains("tired")) {
      response = "Get proper rest. Fatigue can be due to overwork or vitamin deficiency.";
    } else if (message.contains("bp") || message.contains("blood pressure")) {
      response = "Reduce salt, stay calm, and monitor regularly.";
    } else if (message.contains("anxiety") || message.contains("stress")) {
      response = "Deep breathing, meditation, and talking helps. You're not alone 💜";
    } else if (message.contains("depression")) {
      response = "Reach out to someone. Seek professional help if you're overwhelmed.";
    } else if (message.contains("burn")) {
      response = "Cool water + burn ointment. Keep it clean and uncovered.";
    } else if (message.contains("cut")) {
      response = "Clean with antiseptic, apply bandage. Deep cuts need stitches.";
    } else if (message.contains("skin") || message.contains("rash")) {
      response = "Skin rashes can be allergies. Try calamine or consult skin specialist.";
    } else if (message.contains("oxygen")) {
      response = "Use pulse oximeter and log manually on the Heart Rate page.";
    } else if (message.contains("how are you")) {
      response = "I’m a bot but feeling smart today! 😄 Ask me anything health-related.";
    }

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        chatMessages.add({"sender": "Bot", "text": response});
      });
    });
  }

  Widget _buildMessage(Map<String, String> msg) {
    bool isUser = msg['sender'] == userName;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? Colors.deepPurple.shade100 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg['text'] ?? '',
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with HealthBot"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Image.asset('assets/cc.jpeg', height: 100, fit: BoxFit.contain),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Ask any health query below…",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: const EdgeInsets.only(top: 4),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) => _buildMessage(chatMessages[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _handleSend(_controller.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}