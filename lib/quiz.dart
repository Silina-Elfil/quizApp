import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'scorepage.dart';

const String _baseURL = 'silinaapp.000webhostapp.com';

void main() {
  runApp(MyApp());
}

class Question {
  final int id;
  final String question;
  final String answer1;
  final String answer2;
  final String correctAnswer;

  Question(this.id, this.question, this.answer1, this.answer2, this.correctAnswer);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Quiz(),
    );
  }
}

class Quiz extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<Quiz> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  int selectedButtonIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final url = Uri.https(_baseURL, 'getQuestions.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      for (var question in jsonResponse) {
        questions.add(Question(
          int.parse(question['id']),
          question['question'],
          question['answer1'],
          question['answer2'],
          question['correct_answer'],
        ));
      }
      setState(() {});
    } else {
      print('Failed to load questions');
    }
  }

  void checkAnswer(String selectedAnswer, int buttonIndex) {
    if (selectedButtonIndex != -1) {
      // Answer already selected, do nothing
      return;
    }

    setState(() {
      selectedButtonIndex = buttonIndex;
      if (selectedAnswer == questions[currentQuestionIndex].correctAnswer) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (selectedButtonIndex == -1) {
      // No answer selected, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You should answer the question'),
        ),
      );
      return;
    }
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedButtonIndex = -1; // Reset selected button index
      });
    } else {
      // Quiz completed, navigate to the score page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ScorePage(
            score: score,
            totalQuestions: questions.length,
            stars: 0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.blue,
                  child: Text(
                    'Score: $score',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: screenSize.width*0.8,
                //height: screenSize.height*0.3,
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Question ${currentQuestionIndex + 1}:',
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        questions[currentQuestionIndex].question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    checkAnswer(questions[currentQuestionIndex].answer1, 0),
                style: ElevatedButton.styleFrom(
                  primary: selectedButtonIndex == 0
                      ? questions[currentQuestionIndex].answer1 ==
                      questions[currentQuestionIndex].correctAnswer
                      ? Colors.green
                      : Colors.red
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  minimumSize: Size(
                      screenSize.width*0.8,
                      screenSize.height*0.5)
                ),
                child: Text(questions[currentQuestionIndex].answer1),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () =>
                    checkAnswer(questions[currentQuestionIndex].answer2, 1),
                style: ElevatedButton.styleFrom(
                  primary: selectedButtonIndex == 1
                      ? questions[currentQuestionIndex].answer2 ==
                      questions[currentQuestionIndex].correctAnswer
                      ? Colors.green
                      : Colors.red
                      : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    minimumSize: Size(
                        screenSize.width*0.8,
                        screenSize.height*0.5)
                ),
                child: Text(questions[currentQuestionIndex].answer2),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => nextQuestion(),
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
