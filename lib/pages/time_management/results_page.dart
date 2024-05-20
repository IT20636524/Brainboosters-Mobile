import 'package:flutter/material.dart';
import 'package:learning_pose_detection_example/core/connection_strings.dart';
import 'package:learning_pose_detection_example/models/timer_provider.dart';
import 'package:learning_pose_detection_example/pages/home_page.dart';
import 'dart:math';
import 'dart:convert';
import 'package:learning_pose_detection_example/values/papers/task_management_activities.dart';
import 'package:learning_pose_detection_example/pages/time_management/levels_page.dart';
import 'package:learning_pose_detection_example/values/papers/time_advices.dart';
import 'package:learning_pose_detection_example/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ResultsPage extends StatefulWidget {
  final int score;
  final int total;
  final String additionalDetails;
  final int time;

  ResultsPage({
    required this.score,
    required this.total,
    required this.additionalDetails,
    required this.time,
  });

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late TimerProvider timerProvider;
  String advice = '';
  int difficultyFactor = 1;

  @override
  void initState() {
    super.initState();
    timerProvider = Provider.of<TimerProvider>(context, listen: false);
    timerProvider.timerState;
    _calculateAdvice();
    _calculateDifficultyFactor();
    _sendTaskDetails();
  }

  void _calculateAdvice() {
    double percentage = (widget.score / widget.total) * 100;

    for (var rangeAdvice in markingRangeAdvice) {
      List<String> range = rangeAdvice['range'].split('-');
      int lowerBound = int.parse(range[0]);
      int upperBound = int.parse(range[1]);

      if (percentage >= lowerBound && percentage <= upperBound) {
        List<dynamic> adviceList = rangeAdvice['advice'];
        advice = adviceList[Random().nextInt(adviceList.length)];
        break;
      }
    }
  }

  void _calculateDifficultyFactor() {
    var diff = 1;
    double percentage = (widget.score / widget.total) * 100;
    print(percentage);
    double timeFactor = ((0.1 * widget.time) / 60).clamp(1, 5);
    print(timeFactor);
    if (percentage >= 90) {
      diff = (5 - timeFactor).toInt().clamp(1, 5);
    } else if (percentage >= 75) {
      diff = (4 - timeFactor).toInt().clamp(1, 5);
    } else if (percentage >= 50) {
      diff = (3 - timeFactor).toInt().clamp(1, 5);
    } else if (percentage >= 25) {
      diff = (2 - timeFactor).toInt().clamp(1, 5);
    } else {
      diff = (1 - timeFactor).toInt().clamp(1, 5);
    }
    setState(() {
      difficultyFactor = diff;
    });
  }

  void _sendTaskDetails() async {
    try {
      final url = Uri.parse(DB_CONNECTION_STRING + '/api/task');

      final requestData = {
        "points": (widget.score / widget.total * 100).toString(),
        "test": 'Level $difficultyFactor', // Change as needed
        "childName": 'John Doe', // Change as needed
        "takenTime": widget.time.toString(), // Corrected parameter name
        "difficulty": difficultyFactor.toString(),
        "takenDate": "2024-05-18T12:00:00Z",
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        print('Task details sent successfully.');
      } else {
        print('Failed to send task details. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending task details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String timerString = Duration(seconds: widget.time).toString().split('.').first.padLeft(8, "0");

    return Scaffold(
      appBar: CustomAppBar(
        windowName: 'Results',
        pageDescription: 'Your Performance',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top section with score and result text
          Container(
            height: MediaQuery.of(context).size.height * 0.38,
            color: Colors.deepPurple, // Set the container color to purple
            child: Padding(
              padding: const EdgeInsets.all(20), // Add padding for inside components
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Score',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    '${widget.score} / ${widget.total}', // Display the score here
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "You Achieved Tasks in",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    timerString,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded section for additional details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple, // Set text color to purple
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    advice, // Display the advice here
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20), // Adjust spacing
                  Row(
                    children: [
                      Text(
                        'Difficulty Factor: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple, // Set text color to purple
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                              (index) => Icon(
                            index < difficultyFactor ? Icons.star : Icons.star_border,
                            color: index < difficultyFactor ? Colors.yellow : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevelsPage(
                              difficultyFactor: difficultyFactor,
                              additionalTasks: sampleTasks,
                            ),
                          ),
                        );
                      },
                      child: Text('Go to Task Menu'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/home');
                      },
                      child: Text('Go to Home'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
