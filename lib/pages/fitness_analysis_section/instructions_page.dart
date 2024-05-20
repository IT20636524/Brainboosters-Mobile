import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:learning_pose_detection_example/models/exercise_instance_model.dart';
import 'package:learning_pose_detection_example/pages/fitness_analysis_section/pose_levels_page.dart';

class FitnessAnalysisInstructionsPage extends StatefulWidget {


  const FitnessAnalysisInstructionsPage(
      {Key? key})
      : super(key: key);

  static String routeName = "/fitnessAnalysisInstructions";

  @override
  State<StatefulWidget> createState() => _FitnessAnalysisInstructionsPageState();
}

class _FitnessAnalysisInstructionsPageState extends State<FitnessAnalysisInstructionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posture Analysis Instructions"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard(
              title: "How to Play",
              points: [
                "Before each level, you will be shown a video with a sequence of poses",
                "Memorise the poses in correct order and click play when you're ready",
                "Re-create the poses in correct order after the camera opens.",
              ],
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "What to Consider Before Playing",
              points: [
                "Place your phone in a place with good lighting so you are properly visible to the camera",
                "It would be helpful to identify your poses if you could wear clothes that are not too baggy",
                "It is better to wear clothes in contrast with the color of your background",
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PoseLevelsPage(),
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

  Widget _buildCard({required String title, required List<String> points}) {
    return Card(
      color: Colors.deepPurpleAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...points.map((point) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "• ",
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            )).toList(),
          ],
        ),
      ),
    );
  }
}
