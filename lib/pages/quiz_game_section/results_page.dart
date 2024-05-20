import 'package:flutter/material.dart';
import 'package:learning_pose_detection_example/core/connection_strings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/mcq_paper.dart';

class ResultsPage extends StatefulWidget {
  final String emotion;
  final List<MCQPaper> papers;

  const ResultsPage({Key? key, required this.emotion, required this.papers})
      : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final List<String> _difficultyLevels = ['Easy', 'Medium', 'Hard'];
  String _selectedDifficulty = 'Easy';

  Future<void> sendQuizRecord() async {
    try {
      final apiUrl = Uri.parse('$DB_CONNECTION_STRING/api/quiz');

      final requestData = {
        "childName": "John Doe",
        "takenDate": DateTime.now().toIso8601String(),
        "points": "75",
        "emotion": widget.emotion,
        "testName": "Emotion Detection Quiz",
        "timeTaken": "60"
      };

      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        print('Quiz record sent successfully.');
      } else {
        print('Failed to send quiz record. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending quiz record: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Well done, here are your results:",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Your mood after the quiz was : " + widget.emotion,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ...widget.papers.map(
                    (paper) {
                      var totalQuestions = paper.questions.length;
                      var totalCorrect = paper.questions
                          .where((question) =>
                              question.selectedAnswer ==
                              question.options
                                  .firstWhere((option) => option.isCorrect)
                                  .id)
                          .length;
                      var percentage = (totalCorrect / totalQuestions) * 100;
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                paper.paperName,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Total Questions: $totalQuestions",
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Total Correct: $totalCorrect",
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Percentage: ${percentage.toStringAsFixed(2)}%",
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      sendQuizRecord();
                      Navigator.popAndPushNamed(context, '/quizStartPage');
                    },
                    child: const Text("Submit and go back"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
