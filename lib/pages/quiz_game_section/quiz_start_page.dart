import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning_pose_detection_example/pages/quiz_game_section/quiz_page.dart';

import '../../models/mcq_paper.dart';
import '../../values/consts/app_values.dart';
import '../../values/consts/text_style.dart';
import '../../values/papers/logical.dart';
import '../../values/papers/problem_solving.dart';
import '../../values/papers/word_picture_matching.dart';

class QuizStartPage extends StatefulWidget {
  static String routeName = "/quizStartPage";

  @override
  State<QuizStartPage> createState() => _QuizStartPageState();
}

class _QuizStartPageState extends State<QuizStartPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurpleAccent, Colors.purple],
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              Image.asset(
                "assets/images/balloon.png",
              ),
              const SizedBox(height: 20),
              normalText(color: lightGrey, size: 18, text: "Welcome to the"),
              headingText(color: Colors.white, size: 32, text: "Quiz Game"),
              const SizedBox(height: 20),
              normalText(
                  color: lightGrey,
                  size: 16,
                  text: "Do you feel confident and patient ? , "),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => EmotionDetectPage()));
                    var papers;
                    papers = List<MCQPaper>.from(
                      [wordPictureMatching, problemSolving, logical],
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(
                          papers: papers,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    width: size.width - 100,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: headingText(color: blue, size: 18, text: "Continue"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
