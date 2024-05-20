import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:learning_pose_detection/services/cache_service.dart';
import 'package:learning_pose_detection_example/pages/fitness_analysis_section/watch_video_page.dart';

import '../../models/exercise_instance_model.dart';

class LevelResultsPage extends StatefulWidget {
  final String level;
  final List<String> positions;
  final FirebaseAnalytics analytics;
  final ExerciseInstance exerciseInstance;

  const LevelResultsPage({
    Key? key,
    required this.level,
    required this.positions,
    required this.analytics,
    required this.exerciseInstance,
  }) : super(key: key);

  @override
  State<LevelResultsPage> createState() => _LevelResultsPageState();
}

class _LevelResultsPageState extends State<LevelResultsPage> {
  double levelScore = 0.0;

  @override
  void initState() {
    super.initState();
    getMarksFromAnalysis();
  }

  Future<void> getMarksFromAnalysis() async {
    for (String positions in widget.positions) {
      print("All the level " + widget.level + "positions are ");
      print(positions);
      print("////////////////////////////////////////////");
    }

    if (widget.level == "One") {
      print("came to one");
      const int totalMarks = 10;
      final correctSequence = ['Posture 7', 'Posture 2', 'Posture 5'];
      final positions = removeExcessDuplicates(widget.positions);
      levelScore = calculateGrade(correctSequence, positions, totalMarks);
      print("Level one score is " + levelScore.toString());
      await setLevelOneScore(levelScore);
      setState(() {});
    } else if (widget.level == "Two") {
      print("came to two");
      const int totalMarks = 30;
      final correctSequence = [
        'Posture 1',
        'Posture 6',
        'Posture 4',
        'Posture 7'
      ];
      final positions = removeExcessDuplicates(widget.positions);
      levelScore = calculateGrade(correctSequence, positions, totalMarks);
      print("Level two score is " + levelScore.toString());
      await setLevelTwoScore(levelScore);
      setState(() {});
    } else if (widget.level == "Three") {
      print("came to three");
      const int totalMarks = 50;
      final correctSequence = [
        'Posture 4',
        'Posture 7',
        'Posture 2',
        'Posture 6',
        'Posture 1'
      ];
      final positions = removeExcessDuplicates(widget.positions);
      levelScore = calculateGrade(correctSequence, positions, totalMarks);
      print("Level three score is " + levelScore.toString());
      await setLevelThreeScore(levelScore);
      setState(() {});
    }
  }

  double calculateGrade(
      List<String> correctSequence, List<String> userList, int totalMarks) {
    print("came to marks");
    double marks = 0.0;
    final maxGradePerElement = totalMarks / correctSequence.length;
    int correctIndex = 0; // Index to track the correct sequence

    for (String posture in userList) {
      print("came to marks1");
      if (correctIndex < correctSequence.length &&
          posture == correctSequence[correctIndex]) {
        print("came to marks2");
        marks += maxGradePerElement;
        correctIndex++;
      }
    }

    return marks;
  }

  List<String> removeExcessDuplicates(List<String> postureList) {
    List<String> uniquePostures = [];
    String? previousPosture = null;

    for (String posture in postureList) {
      if (posture != previousPosture) {
        uniquePostures.add(posture);
        previousPosture = posture;
      }
    }

    for (String positions in uniquePostures) {
      print("uniquePostures " + widget.level + "positions are ");
      print(positions);
      print("////////////////////////////////////////////");
    }
    return uniquePostures;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level" + widget.level + "Results"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Level " + widget.level,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Your level score is : " + levelScore.toString(),
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // ElevatedButton(
            //   onPressed: () {
            //     if (widget.level == "One") {
            //       Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => ExerciseVideoPage(
            //             analytics: widget.analytics,
            //             exerciseInstance: widget.exerciseInstance,
            //             videoPath: 'assets/videos/2.mp4',
            //           ),
            //         ),
            //       );
            //     } else if (widget.level == "Two") {
            //       Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => ExerciseVideoPage(
            //             analytics: widget.analytics,
            //             exerciseInstance: widget.exerciseInstance,
            //             videoPath: 'assets/videos/3.mp4',
            //           ),
            //         ),
            //       );
            //     }
            //   },
            //   child: Text("Proceed to next level"),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Color(0xFF527EEF),
            //     foregroundColor: Colors.white,
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            //     textStyle: const TextStyle(fontSize: 20),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
