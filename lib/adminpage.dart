import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _baseURL = 'silinaapp.000webhostapp.com'; // Replace with your API base URL

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminPage(),
    );
  }
}

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answer1Controller = TextEditingController();
  TextEditingController answer2Controller = TextEditingController();
  TextEditingController correctAnswerController = TextEditingController();

  Future<void> insertQuestion() async {
    final url = Uri.https(_baseURL, 'insertQuestion.php');
    final response = await http.post(
      url,
      body: {
        'question': questionController.text,
        'answer1': answer1Controller.text,
        'answer2': answer2Controller.text,
        'correct_answer': correctAnswerController.text,
      },
    );

    if (response.statusCode == 200) {
      print('Question inserted successfully');
      // Optionally, you can show a success message or clear the text fields.
    } else {
      print('Failed to insert question');
      // Optionally, you can show an error message.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: answer1Controller,
              decoration: const InputDecoration(labelText: 'Answer 1'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: answer2Controller,
              decoration: const InputDecoration(labelText: 'Answer 2'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: correctAnswerController,
              decoration: const InputDecoration(labelText: 'Correct Answer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: insertQuestion,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
            ),
              child: const Text('Insert Question'),
            ),
          ],
        ),
      ),
    );
  }
}
