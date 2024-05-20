import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:learning_pose_detection_example/pages/fitness_analysis_section/poisture_analysis_start_page.dart';
import 'package:learning_pose_detection_example/pages/games_section/games_start_page.dart';
import 'package:learning_pose_detection_example/pages/time_management/levels_page.dart';
import 'package:learning_pose_detection_example/pages/time_management/time_start_page.dart';

class HomePage extends StatelessWidget {
  final FirebaseAnalytics analytics;

  HomePage({Key? key, required this.analytics}) : super(key: key);

  static const String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [],
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.transparent, // Make background transparent
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurpleAccent, Colors.purple], // Use gradient colors
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                _buildTitleView("Welcome to the App"),
                SizedBox(height: 20),
                _buildImageRow(
                  context,
                  imageAsset: "assets/images/puzzle.jpg",
                  text: 'Games',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChildrenGamesStartPage(),
                      ),
                    );
                  },
                ),
                _buildImageRow(
                  context,
                  imageAsset: "assets/images/movements.jpg",
                  text: 'Posture Analysis',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PoistureAnalysisStartPage(),
                      ),
                    );
                  },
                ),
                _buildImageRow(
                  context,
                  imageAsset: "assets/images/quiz_image.jpeg",
                  text: 'Quiz Game',
                  onTap: () {
                    Navigator.pushNamed(context, "/quizStartPage");
                  },
                ),
                _buildImageRow(
                  context,
                  imageAsset: "assets/images/time-management.jpg",
                  text: 'Time Management',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimeManagementStartPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleView(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white, // Change text color to white
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildImageRow(
      BuildContext context, {
        required String imageAsset,
        required String text,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white, // Change text color to white
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
