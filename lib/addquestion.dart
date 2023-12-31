import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _baseURL = 'silinaapp.000webhostapp.com'; // Replace with your API base URL

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddQuestion(),
    );
  }
}

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Question inserted successfully'),
          duration: Duration(seconds: 2), // Optional: Set the duration
        ),
      );
      // Optionally, you can show a success message or clear the text fields.
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to insert question'),
          duration: Duration(seconds: 2), // Optional: Set the duration
        ),
      );
      // Optionally, you can show an error message.
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
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
                minimumSize: Size(screenSize.width*0.2, 40),
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
