import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ⚠️ REPLACE with your actual OpenAI API key
const String apiKey = 'sk-ijklmnopqrstuvwxijklmnopqrstuvwxijklmnop';

class DirectOpenAIChat extends StatefulWidget {
  @override
  _DirectOpenAIChatState createState() => _DirectOpenAIChatState();
}

class _DirectOpenAIChatState extends State<DirectOpenAIChat> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> sendMessage(String message) async {
    setState(() {
      _messages.add({"sender": "user", "text": message});
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {"role": "system", "content": "You are a helpful healthcare assistant."},
          {"role": "user", "content": message}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final reply = jsonDecode(response.body)['choices'][0]['message']['content'];
      setState(() {
        _messages.add({"sender": "bot", "text": reply});
        _isLoading = false;
      });
    } else {
      setState(() {
        _messages.add({"sender": "bot", "text": "⚠️ Error: ${response.statusCode}"} );
        _isLoading = false;
      });
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Healthcare AI Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12),
              children: _messages.map((msg) {
                return Align(
                  alignment: msg['sender'] == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: msg['sender'] == 'user' ? Colors.green[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg['text'] ?? ''),
                  ),
                );
              }).toList()
                + (_isLoading
                    ? [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      ]
                    : []),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Ask a health question...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    sendMessage(_controller.text.trim());
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
