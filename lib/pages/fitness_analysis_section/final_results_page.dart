import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:learning_pose_detection/services/cache_service.dart';
import 'package:learning_pose_detection_example/models/exercise_instance_model.dart';
import 'package:learning_pose_detection_example/pages/home_page.dart';

class FinalResultsPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final ExerciseInstance exerciseInstance;
  final double levelOneScore;
  final double levelTwoScore;
  final double levelThreeScore;

  const FinalResultsPage({
    Key? key,
    required this.analytics,
    required this.exerciseInstance,
    required this.levelOneScore,
    required this.levelTwoScore,
    required this.levelThreeScore,
  }) : super(key: key);

  static String routeName = "/fitnessResults";

  @override
  _FinalResultsPageState createState() => _FinalResultsPageState();
}

class _FinalResultsPageState extends State<FinalResultsPage> {
  double finalScore = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalScore();
  }

  getTotalScore() {
    finalScore =
        widget.levelOneScore + widget.levelTwoScore + widget.levelThreeScore;
    setState(() {});
  }

  Future<void> saveScore(double finalScore) async {
    EasyLoading.show(
        status: "Saving your details please wait...", dismissOnTap: false);
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where there's no logged-in user (e.g., with an error)
      return;
    }

    // Access FireStore instance
    final fireStore = FirebaseFirestore.instance;

    // Create the data to save
    final data = {
      'displayName': user.displayName,
      'finalScore': finalScore,
    };

    // Add the data to the "results" collection with the user's ID as the document ID
    await fireStore.collection('results').doc(user.uid).set(data);
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Final Result"),
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
                    "Level One Score " + widget.levelOneScore.toString(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
                    "Level Two Score " + widget.levelTwoScore.toString(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
                    "Level Three Score " + widget.levelThreeScore.toString(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
                    "Final Score " + finalScore.toString(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await removeLevelOneScore();
                await removeLevelTwoScore();
                await removeLevelThreeScore();
                await saveScore(finalScore);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomePage(
                      analytics: widget.analytics,
                    );
                  }),
                );
              },
              child: Text("Done"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF527EEF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
