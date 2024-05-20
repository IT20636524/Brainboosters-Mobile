import 'package:flutter/material.dart';
import 'package:learning_pose_detection_example/pages/fitness_analysis_section/watch_video_page.dart';
import 'package:learning_pose_detection_example/widgets/custom_appbar.dart';

class PoseLevelsPage extends StatelessWidget {
  final List<Map<String, dynamic>> markingRangeAdvice = [
    {
      "level": 1,
      "description": 'Some information on level 01',
      "video": "assets/videos/1.mp4",
      "poses": ["Pose 01", "Pose 02"],
      "marks": 10,
    },
    {
      "level": 2,
      "description": 'Some information on level 02',
      "video": "assets/videos/2.mp4",
      "poses": ["Pose 01", "Pose 02"],
      "marks": 10,
    },
    {
      "level": 3,
      "description": 'Some information on level 03',
      "video": "assets/videos/3.mp4",
      "poses": ["Pose 01", "Pose 02"],
      "marks": 20,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        windowName: 'Pose Levels',
        pageDescription: 'Shows list of levels available to you',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top section with description and image
          Container(
            height: MediaQuery.of(context).size.height * 0.38,
            color: Colors.deepPurpleAccent,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Some Description on Pose Levels. Select one of below to start.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/fitness_icon.png',
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
          // Expanded section for the list view of levels
          Expanded(
            child: ListView.builder(
              itemCount: markingRangeAdvice.length,
              itemBuilder: (context, index) {
                final level = markingRangeAdvice[index];
                final levelNumber = level['level'];
                final description = level['description'];
                final video = level['video'];
                final poses = List<String>.from(level['poses']);
                final marks = level['marks'];

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
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ExerciseVideoPage(
                        //       videoPath: video,
                        //     ),
                        //   ),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Level $levelNumber',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(description),
                            const SizedBox(height: 5),
                            Text('Poses: ${poses.join(", ")}'),
                            const SizedBox(height: 5),
                            Text('Marks: $marks'),
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
      ),
    );
  }
}
