import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../main.dart';
import '../../models/exercise_instance_model.dart';

class ExerciseVideoPage extends StatefulWidget {
  final String videoPath;
  final FirebaseAnalytics analytics;
  final ExerciseInstance exerciseInstance;

  const ExerciseVideoPage(
      {Key? key,
      required this.videoPath,
      required this.analytics,
      required this.exerciseInstance
      })
      : super(key: key);

  @override
  State<ExerciseVideoPage> createState() => _ExerciseVideoPageState();
}

class _ExerciseVideoPageState extends State<ExerciseVideoPage> {
  late VideoPlayerController _controller;
  String selectedTime = "0.5 minutes";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {}); // Update the UI when the video is ready
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Video Demonstration')),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 64),
                const Text(
                  "Watch this video and get ready to start!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _controller.pause();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(width: 1.0, color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          Positioned(
                            // Overlay for play icon
                            bottom: 10.0,
                            right: 10.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: IconButton(
                                iconSize: 20.0,
                                icon: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
                                },
                              ),
                            ),
                          ),
                          // Integrated video progress and controls
                          VideoProgressIndicator(_controller,
                              allowScrubbing: true),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  " Select the total time you want to practice for. ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                DropdownButton(
                  items: const [
                    DropdownMenuItem(
                      child: Text("30 seconds"),
                      value: "0.5 minutes",
                    ),
                    DropdownMenuItem(
                      child: Text("1 minutes"),
                      value: "1.0 minutes",
                    ),
                    DropdownMenuItem(
                      child: Text("1.5 minutes"),
                      value: "1.5 minutes",
                    ),
                    DropdownMenuItem(
                      child: Text("2 minutes"),
                      value: "2.0 minutes",
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedTime = value.toString();
                    });
                  },
                  value: selectedTime,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    String time = "";
                    if (selectedTime == "0.5 minutes") {
                      time = "30";
                    } else if (selectedTime == "1.0 minutes") {
                      time = "60";
                    } else if (selectedTime == "1.5 minutes") {
                      time = "90";
                    } else if (selectedTime == "2.0 minutes") {
                      time = "120";
                    }
                    widget.exerciseInstance.setCurrentExerciseTime(
                        getTimeFromString(selectedTime));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PoseDetectionPage(
                          analytics: widget.analytics,
                          exerciseInstance: widget.exerciseInstance,
                          selectedTime: time,
                        ),
                      ),
                    );
                  },
                  child: const Text("Get Started"),
                ),
              ],
            ),
          ),
        ));
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
