import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learning_pose_detection_example/models/task_management.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnswerPage extends StatefulWidget {
  final TaskManagementQuestion question;

  AnswerPage({required this.question});

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  List<String> droppedAnswers = [];
  List<String> remainingTasks = [];
  int triesLeft = 3; // Number of tries allowed
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    // Initialize remainingTasks with the tasks from the question
    remainingTasks.addAll(widget.question.tasks);
  }

  bool checkAnswer() {
    print(droppedAnswers);
    print(widget.question);
    isCorrect = droppedAnswers.join(',') == widget.question.answer.join(',');
    return isCorrect;
  }

  void removeTask(String task) {
    setState(() {
      remainingTasks.add(task);
      droppedAnswers.remove(task);
    });
  }

  void confirmAnswer(BuildContext context) async {
    bool correctAnswer = checkAnswer();

    if (correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Correct Answer!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, isCorrect);
    } else {
      triesLeft--;

      if (triesLeft == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect Answer! No more tries left.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context, isCorrect);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect Answer! Tries left: $triesLeft'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer'),
      ),
      body: Builder(
        builder: (context) { // Create a new BuildContext with a ScaffoldMessenger ancestor
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.question.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Question: ${widget.question.question}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tasks:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              // Display tasks
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: remainingTasks.map((task) {
                  return Draggable<String>(
                    data: task,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('- $task'),
                    ),
                    feedback: Material(
                      elevation: 8.0,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        child: Text(task),
                      ),
                    ),
                    childWhenDragging: Container(), // Empty container when dragging
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              DragTarget<String>(
                onWillAccept: (data) => true,
                onAccept: (data) {
                  setState(() {
                    droppedAnswers.add(data!);
                    remainingTasks.remove(data);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: double.infinity,
                    height: 100,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Drag Answers HERE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Order of dropped answers:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: droppedAnswers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                      title: Row(
                        children: [
                          Expanded(child: Text('${index + 1}. ${droppedAnswers[index]}')),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              removeTask(droppedAnswers[index]);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Go Back'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Confirm answer
                      confirmAnswer(context);
                    },
                    child: Text('Confirm Answer'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
            ],
          );
        },
      ),
    );
  }
}

