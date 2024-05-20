import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learning_pose_detection_example/pages/time_management/results_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_pose_detection_example/models/task_management.dart';
import 'package:learning_pose_detection_example/pages/time_management/answer_page.dart';
import 'package:learning_pose_detection_example/widgets/custom_appbar.dart';

class TasksPage extends StatefulWidget {
  final List<TaskManagementQuestion> tasks;
  final Map<String, dynamic> level;

  TasksPage({required this.tasks, required this.level});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  int _currentStep = 0;
  late SharedPreferences _prefs;
  bool _isAnswering = false;
  List<bool?> _results = [];
  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _startTimer();
    print(widget.tasks);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    // Initialize _results list based on the number of tasks
    _results = List.generate(widget.tasks.length, (index) => null);
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        setState(() {
          _elapsedSeconds++;
        });
      },
    );
  }

  Future<void> _storeResult(int index, bool isCorrect) async {
    setState(() {
      if (index >= 0 && index < _results.length) {
        _results[index] = isCorrect;
        print(_results);
      } else {
        // Handle invalid index here
        print('Invalid index: $index');
      }
    });
  }

  bool? _getResult(int index) {
    return _results[index];
  }

  int _calculateScore() {
    int score = _results.where((result) => result == true).length;
    return score;
  }

  List<dynamic> _buildSteps() {
    List<Step> steps = [];
    int totalSteps = 0; // Variable to store the total step count

    // Group tasks by category and level
    Map<String, Map<String, List<TaskManagementQuestion>>> groupedTasks = {};

    for (var task in widget.tasks) {
      if (!groupedTasks.containsKey(task.category)) {
        groupedTasks[task.category] = {};
      }

      if (!groupedTasks[task.category]!.containsKey(task.difficultyLevel.toString())) {
        groupedTasks[task.category]![task.difficultyLevel.toString()] = [];
      }

      groupedTasks[task.category]![task.difficultyLevel.toString()]!.add(task);
    }

    // Create Steps for each category-level combination
    groupedTasks.forEach((category, levels) {
      levels.forEach((level, tasks) {
        totalSteps++; // Increment the total step count for each level

        List<Widget> taskWidgets = tasks.map((task) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question: ${task.question}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnswerPage(question: task),
                    ),
                  );
                  if (result != null) {
                    int index = widget.tasks.indexWhere((t) => t.question == task.question); // Get index based on the title of the task
                    await _storeResult(index, result);
                  }
                  print(result);
                },
                child: Text('Answer'),
              ),
            ],
          );
        }).toList();

        steps.add(
          Step(
            title: Text('Section: $category'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: taskWidgets,
            ),
            isActive: _currentStep == steps.length, // Make the step active based on the current step index
          ),
        );
      });
    });

    return [steps, totalSteps]; // Return both steps and total step count
  }

  @override
  Widget build(BuildContext context) {
    String timerString = Duration(seconds: _elapsedSeconds).toString().split('.').first.padLeft(8, "0");
    List<dynamic> stepsAndTotalCount = _buildSteps(); // Get steps and total step count
    List<Step> steps = stepsAndTotalCount[0]; // Extract steps
    int totalSteps = stepsAndTotalCount[1];

    return Scaffold(
      appBar: CustomAppBar(
        windowName: widget.level['name'],
        pageDescription: 'Complete this Level',
        // You can provide the logout function here if needed
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          setState(() {
            if (_currentStep < steps.length - 1) {
              _currentStep += 1;
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep > 0) {
              _currentStep -= 1;
            }
          });
        },
        steps: steps,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (_currentStep > 0)
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentStep -= 1;
                  });
                },
              ),
            Text(timerString, style: TextStyle(fontSize: 20)), // Display Timer
            if (_currentStep < totalSteps - 1)
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    _currentStep += 1;
                  });
                },
              ),
            if (_currentStep == totalSteps - 1)
              TextButton(
                onPressed: () {
                  int score = _calculateScore(); // Calculate score
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultsPage(
                        score: score,
                        total: widget.tasks.length,
                        additionalDetails: '',
                        time: _elapsedSeconds
                      ),
                    ),
                  );
                  // Handle confirmation action
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmation'),
                        content: Text('Are you sure you want to confirm?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle confirmation action
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Confirm'),
              ),
          ],
        ),
      ),
    );
  }
}
