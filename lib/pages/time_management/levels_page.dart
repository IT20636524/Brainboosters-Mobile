import 'package:flutter/material.dart';
import 'package:learning_pose_detection_example/models/timer_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:learning_pose_detection_example/models/task_management.dart';
import 'package:learning_pose_detection_example/pages/time_management/tasks_page.dart';
import 'package:learning_pose_detection_example/widgets/custom_appbar.dart';

class LevelsPage extends StatefulWidget {
  final int difficultyFactor;
  final List<TaskManagementQuestion> additionalTasks;

  LevelsPage({required this.difficultyFactor, required this.additionalTasks});

  @override
  _LevelsPageState createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> {
  late Timer timer;
  late Timer _timer;
  int _elapsedSeconds = 60;
  late int elapsedSeconds;
  String timerString = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
    elapsedSeconds = Provider.of<TimerProvider>(context, listen: false).elapsedSeconds;
    timerString = Duration(seconds: elapsedSeconds).toString().split('.').first.padLeft(8, "0");
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
        timerString = Duration(seconds: elapsedSeconds).toString().split('.').first.padLeft(8, "0");
      });
    });
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

  @override
  void dispose() {
    timer.cancel();
    _timer.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> levels = [
    {
      'name': 'Level 1',
      'description': 'Description of Level 1',
      'categories': ['Personal', 'Homestead', 'School'],
      'threshold': 60, // Time threshold for unlocking level 1 (in seconds)
    },
    {
      'name': 'Level 2',
      'description': 'Description of Level 2',
      'categories': ['Personal', 'Homestead', 'Garden'],
      'threshold': 120, // Time threshold for unlocking level 2 (in seconds)
    },
    {
      'name': 'Level 3',
      'description': 'Description of Level 3',
      'categories': ['Personal', 'Homestead', 'Garden'],
      'threshold': 180, // Time threshold for unlocking level 3 (in seconds)
    },
  ];

  List<TaskManagementQuestion> getTasksByCategory(String category) {
    return widget.additionalTasks.where((task) => task.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        windowName: 'Levels',
        pageDescription: 'Choose a Level $timerString',
      ),
      body: Consumer<TimerProvider>(
        builder: (context, timerProvider, child) {
          final elapsedSeconds = timerProvider.elapsedSeconds;
          timerString = Duration(seconds: elapsedSeconds).toString().split('.').first.padLeft(8, "0");

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top section with description and image
              Container(
                height: MediaQuery.of(context).size.height * 0.38,
                color: Colors.deepPurpleAccent, // Adjust the color as needed
                child: Padding(
                  padding: const EdgeInsets.all(20), // Add padding for inside components
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Some Description on Task management Activity. Select one of below to start.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Image.asset(
                        'assets/images/task-management.png', // Provide the image path
                        height: 100, // Adjust the image height as needed
                      ),
                    ],
                  ),
                ),
              ),

              // Expanded section for the list view of levels
              Expanded(
                child: ListView.builder(
                  itemCount: levels.length, // Replace with your levels list
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    final categories = (level['categories'] as List<String>).take(3).toList();
                    final threshold = level['threshold'] as int;

                    // Determine if the level is locked or unlocked based on elapsed time
                    final isLocked = _elapsedSeconds < threshold;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                        elevation: 5,
                        shadowColor: Colors.grey,
                        child: InkWell(
                          onTap: isLocked
                              ? null // Level is locked, disable onTap
                              : () {
                            // Filter tasks based on categories and difficulty level
                            List<TaskManagementQuestion> filteredTasks = [];
                            categories.forEach((category) {
                              filteredTasks.addAll(
                                  getTasksByCategory(category).where((task) => task.difficultyLevel == widget.difficultyFactor).take(1));
                            });

                            // Navigate to the next page with filtered tasks
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TasksPage(
                                  tasks: filteredTasks,
                                  level: level,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level['name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(level['description']),
                                SizedBox(height: 5),
                                Text('Difficulty Level: ${widget.difficultyFactor}'),
                                SizedBox(height: 5),
                                Text('Categories: ${categories.join(", ")}'),
                                SizedBox(height: 5),
                                Text('Threshold: ${level['threshold']} seconds'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
