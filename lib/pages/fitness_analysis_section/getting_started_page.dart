import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:learning_pose_detection_example/models/exercise_instance_model.dart';
import 'package:learning_pose_detection_example/pages/fitness_analysis_section/instructions_page.dart';
import 'package:learning_pose_detection_example/pages/fitness_analysis_section/pose_levels_page.dart';
import 'package:learning_pose_detection_example/pages/fitness_analysis_section/watch_video_page.dart';

class FitnessAnalysisStartPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final ExerciseInstance exerciseInstance;

  const FitnessAnalysisStartPage(
      {Key? key, required this.analytics, required this.exerciseInstance})
      : super(key: key);

  static String routeName = "/fitnessAnalysisStart";

  @override
  State<StatefulWidget> createState() => _FitnessAnalysisStartPageState();
}

class _FitnessAnalysisStartPageState extends State<FitnessAnalysisStartPage> {
  String selectedTime = "0.5 minutes";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posture Analysis"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Keep the phone upright\nfor better posture!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/exercise_correct_posture.jpg",
              fit: BoxFit.contain,
              height: 300,
            ),
            const SizedBox(height: 20),
            const Text(
              " Get ready to test your skills",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            // const SizedBox(height: 20),
            // DropdownButton(
            //   items: const [
            //     DropdownMenuItem(
            //       child: Text("30 seconds"),
            //       value: "0.5 minutes",
            //     ),
            //     DropdownMenuItem(
            //       child: Text("1 minutes"),
            //       value: "1.0 minutes",
            //     ),
            //     DropdownMenuItem(
            //       child: Text("1.5 minutes"),
            //       value: "1.5 minutes",
            //     ),
            //     DropdownMenuItem(
            //       child: Text("2 minutes"),
            //       value: "2.0 minutes",
            //     ),
            //   ],
            //   onChanged: (value) {
            //     setState(() {
            //       selectedTime = value.toString();
            //     });
            //   },
            //   value: selectedTime,
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FitnessAnalysisInstructionsPage()
                  ),
                );
              },
              child: const Text("Instructions"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseVideoPage(
                      analytics: widget.analytics,
                      exerciseInstance: widget.exerciseInstance,
                      videoPath: 'assets/videos/1.mp4',
                    ),
                  ),
                );

              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }

  int getTimeFromString(String timeString) {
    List<String> timeStringSplit = timeString.split(" ");
    double timeLeftInMinutesAsDouble = double.parse(timeStringSplit[0]);
    int timeLeftInSecondsNew = (timeLeftInMinutesAsDouble * 60).toInt();
    Duration duration = Duration(
        minutes: timeLeftInMinutesAsDouble.toInt(),
        seconds: timeLeftInSecondsNew % 60);
    String formattedTime =
        "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
    return timeLeftInSecondsNew;
  }
}
