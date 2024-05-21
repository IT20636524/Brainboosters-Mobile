import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:learning_pose_detection_example/pages/quiz_game_section/results_page.dart';

import '../../core/connection_strings.dart';
import '../../models/mcq_paper.dart';

class QuizPage extends StatefulWidget {
  final List<MCQPaper> papers;

  const QuizPage({Key? key, required this.papers}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TimePerQuizInNanoSeconds = 90000000000;
  Timer? timer;

  int currentPaperIndex = 0;
  int currentQuestionIndex = 0;
  bool _isAllEnabled = false;
  int _currentTimeInNanoSeconds = 90000000000;
  int qIndex = 0;
  String type = "";

  bool isRed = false;
  bool isGreen = false;
  bool isBlue = false;
  bool isPink = false;

  bool redPressed = false;
  bool greenPressed = false;
  bool bluePressed = false;
  bool pinkPressed = false;

  String levelOneColor = 'red';
  String levelTwoColor = 'pink';
  String levelThreeColorOne = 'red';
  String levelThreeColorTwo = 'pink';

  List<String> colorNamesLevelTwo = ["blue", "pink"];
  List<String> colorNamesLevelThree = ["blue", "pink", "red"];

  bool isFirstImage = false;
  bool isSecondImage = false;
  bool isThirdImage = false;

  String firstEmotion = "";
  String secondEmotion = "";
  String thirdEmotion = "";

  List<String> myEmotionList = [];
  String finalEmotion = "";
  CameraController? controller;
  XFile? selectedImg;
  bool _isTimerPaused = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _disposeCamera();
    super.dispose();
  }

  Future<void> _disposeCamera() async {
    if (controller != null && controller!.value.isInitialized) {
      await controller?.dispose();
      controller = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var question =
        widget.papers[currentPaperIndex].questions[currentQuestionIndex];
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/quiz_back.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "${widget.papers[currentPaperIndex].paperName}",
                      style: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      "Time Remaining: ${_currentTimeInNanoSeconds >= 0 ? (_currentTimeInNanoSeconds / 1000000000 / 60).round().toString() + ":" + (_currentTimeInNanoSeconds / 1000000000 % 60).round().toString().padLeft(2, '0') + " minutes and seconds" : 0}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        widget.papers[currentPaperIndex]
                            .questions[currentQuestionIndex].question,
                        style: const TextStyle(
                            fontSize: 18.0, color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (widget
                                  .papers[currentPaperIndex]
                                  .questions[currentQuestionIndex]
                                  .options
                                  .length /
                              2)
                          .ceil(),
                      itemBuilder: (context, index) {
                        if ((currentPaperIndex == 0 &&
                                currentQuestionIndex == 0) ||
                            (currentPaperIndex == 0 &&
                                currentQuestionIndex == 2) ||
                            (currentPaperIndex == 0 &&
                                currentQuestionIndex == 4)) isRed = true;

                        if ((currentPaperIndex == 0 &&
                                currentQuestionIndex == 1) ||
                            (currentPaperIndex == 0 &&
                                currentQuestionIndex == 3)) isGreen = true;

                        if (currentPaperIndex == 1) isBlue = true;
                        if (currentPaperIndex == 1) isPink = true;

                        if (currentPaperIndex == 2) isBlue = true;
                        if (currentPaperIndex == 2) isPink = true;
                        if (currentPaperIndex == 2) isRed = true;

                        if (currentPaperIndex == 0 && isFirstImage == false) {
                          cancelTimer();
                          print("came here 1");
                          _capturePhotoAndStore();
                          isFirstImage = true;
                        } else if (currentPaperIndex == 1 &&
                            isSecondImage == false) {
                          cancelTimer();
                          print("came here 2");
                          _capturePhotoAndStore();
                          isSecondImage = true;
                        } else if (currentPaperIndex == 2 &&
                            isThirdImage == false) {
                          cancelTimer();
                          print("came here 3");
                          _capturePhotoAndStore();
                          isThirdImage = true;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  title: Image.asset(
                                    widget
                                        .papers[currentPaperIndex]
                                        .questions[currentQuestionIndex]
                                        .options[index * 2]
                                        .answer,
                                    height: 100,
                                  ),
                                  value: widget
                                      .papers[currentPaperIndex]
                                      .questions[currentQuestionIndex]
                                      .options[index * 2]
                                      .id,
                                  groupValue: widget
                                      .papers[currentPaperIndex]
                                      .questions[currentQuestionIndex]
                                      .selectedAnswer,
                                  onChanged: _isAllEnabled
                                      ? (value) {
                                          setState(() {
                                            widget
                                                .papers[currentPaperIndex]
                                                .questions[currentQuestionIndex]
                                                .selectedAnswer = value.toString();
                                          });
                                        }
                                      : null,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: index * 2 + 1 <
                                        widget
                                            .papers[currentPaperIndex]
                                            .questions[currentQuestionIndex]
                                            .options
                                            .length
                                    ? RadioListTile(
                                        title: Image.asset(
                                          widget
                                              .papers[currentPaperIndex]
                                              .questions[currentQuestionIndex]
                                              .options[index * 2 + 1]
                                              .answer,
                                          height: 100,
                                        ),
                                        value: widget
                                            .papers[currentPaperIndex]
                                            .questions[currentQuestionIndex]
                                            .options[index * 2 + 1]
                                            .id,
                                        groupValue: widget
                                            .papers[currentPaperIndex]
                                            .questions[currentQuestionIndex]
                                            .selectedAnswer,
                                        onChanged: _isAllEnabled
                                            ? (value) {
                                                setState(() {
                                                  widget
                                                          .papers[currentPaperIndex]
                                                          .questions[
                                                              currentQuestionIndex]
                                                          .selectedAnswer =
                                                      value.toString();
                                                });
                                              }
                                            : null,
                                      )
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 64.0,
                    ),
                    if (currentPaperIndex == 0)
                      Text(
                        "Select the answer after clicking on the $levelOneColor button",
                        style: TextStyle(fontSize: 16.0, color: Colors.red),
                      ),
                    if (currentPaperIndex == 1)
                      Text(
                        "Select the answer after clicking on the $levelTwoColor button",
                        style: TextStyle(fontSize: 16.0, color: Colors.red),
                      ),
                    if (currentPaperIndex == 2)
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Select the answer after clicking on both $levelThreeColorOne and $levelThreeColorTwo button",
                          style: TextStyle(fontSize: 16.0, color: Colors.red),
                        ),
                      ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (isRed)
                          ElevatedButton(
                            onPressed: () {
                              print("Red Pressed");
                              setState(() {
                                redPressed = true;
                              });

                              if (currentPaperIndex == 0) {
                                _isAllEnabled = true;
                              }

                              if (currentPaperIndex == 2 &&
                                  levelThreeColorOne == 'red' &&
                                  levelThreeColorTwo == 'pink') {
                                _isAllEnabled = true;
                              } else if (currentPaperIndex == 2 &&
                                  levelThreeColorOne == 'red' &&
                                  levelThreeColorTwo == 'blue') {
                                _isAllEnabled = true;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: Text('Red',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                          ),
                        if (isGreen)
                          ElevatedButton(
                            onPressed: () {
                              print("Green Pressed");
                              setState(() {
                                greenPressed = true;
                                _isAllEnabled = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: Text('Green',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                          ),
                        if (isBlue)
                          ElevatedButton(
                            onPressed: () {
                              print("Blue Pressed");
                              setState(() {
                                bluePressed = true;

                                if (currentPaperIndex == 1 &&
                                    levelTwoColor == 'blue') {
                                  _isAllEnabled = true;
                                }

                                if (currentPaperIndex == 2 &&
                                    levelThreeColorOne == 'blue' &&
                                    levelThreeColorTwo == 'pink') {
                                  _isAllEnabled = true;
                                } else if (currentPaperIndex == 2 &&
                                    levelThreeColorOne == 'blue' &&
                                    levelThreeColorTwo == 'red') {
                                  _isAllEnabled = true;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            child: Text('Blue',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                          ),
                        if (isPink)
                          ElevatedButton(
                            onPressed: () {
                              print("Pink Pressed");
                              setState(() {
                                pinkPressed = true;

                                if (currentPaperIndex == 1 &&
                                    levelTwoColor == 'pink') {
                                  _isAllEnabled = true;
                                }

                                if (currentPaperIndex == 2 &&
                                    levelThreeColorOne == 'pink' &&
                                    levelThreeColorTwo == 'red') {
                                  _isAllEnabled = true;
                                } else if (currentPaperIndex == 2 &&
                                    levelThreeColorOne == 'pink' &&
                                    levelThreeColorTwo == 'blue') {
                                  _isAllEnabled = true;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink),
                            child: Text('Pink',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 64.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: ElevatedButton(
                        onPressed: () {
                          print("red pressed is:$redPressed");

                          print("Level3one color is:$levelThreeColorOne");
                          print("Level3two color is:$levelThreeColorTwo");

                          if (currentPaperIndex == 0 &&
                              levelOneColor == "green" &&
                              greenPressed == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please press the green button before answering !"),
                              ),
                            );
                            return;
                          } else if (currentPaperIndex == 0 &&
                              levelOneColor == "red" &&
                              redPressed == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please press the red button before answering !"),
                              ),
                            );
                            return;
                          }

                          if (currentPaperIndex == 1 &&
                              levelTwoColor == 'blue' &&
                              bluePressed == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please press the blue button before answering !"),
                              ),
                            );
                            return;
                          } else if (currentPaperIndex == 1 &&
                              levelTwoColor == 'pink' &&
                              pinkPressed == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please press the pink button before answering !"),
                              ),
                            );
                            return;
                          }

                          if (currentPaperIndex == 2 &&
                              levelThreeColorOne == 'blue' &&
                              levelThreeColorTwo == 'pink') {
                            if (bluePressed == false || pinkPressed == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please press both blue and pink buttons before answering !"),
                                ),
                              );
                              return;
                            }
                          } else if (currentPaperIndex == 2 &&
                              levelThreeColorOne == 'blue' &&
                              levelThreeColorTwo == 'red') {
                            if (bluePressed == false || redPressed == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please press the blue and red button before answering !"),
                                ),
                              );
                              return;
                            }
                          } else if (currentPaperIndex == 2 &&
                              levelThreeColorOne == 'pink' &&
                              levelThreeColorTwo == 'red') {
                            if (pinkPressed == false || redPressed == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please press the pink and red button before answering !"),
                                ),
                              );
                              return;
                            }
                          } else if (currentPaperIndex == 2 &&
                              levelThreeColorOne == 'pink' &&
                              levelThreeColorTwo == 'blue') {
                            if (pinkPressed == false || bluePressed == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please press the pink and blue button before answering !"),
                                ),
                              );
                              return;
                            }
                          } else if (currentPaperIndex == 2 &&
                              levelThreeColorOne == 'red' &&
                              levelThreeColorTwo == 'pink') {
                            if (redPressed == false || pinkPressed == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please press the red and pink button before answering !"),
                                ),
                              );
                              return;
                            }
                          } else if (currentPaperIndex == 2 &&
                              levelThreeColorOne == 'red' &&
                              levelThreeColorTwo == 'blue') {
                            if (redPressed == false || bluePressed == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please press the red and blue button before answering !"),
                                ),
                              );
                              return;
                            }
                          }

                          var question = widget.papers[currentPaperIndex]
                              .questions[currentQuestionIndex];
                          if (question.selectedAnswer.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select an answer!"),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _isAllEnabled = true;
                          });
                          bool isAnswerCorrect = false;
                          widget
                              .papers[currentPaperIndex]
                              .questions[currentQuestionIndex]
                              .timeTaken = (TimePerQuizInNanoSeconds -
                                  _currentTimeInNanoSeconds) /
                              1000000000 /
                              60;
                          for (var option in question.options) {
                            if (option.id == question.selectedAnswer) {
                              if (option.isCorrect) {
                                isAnswerCorrect = true;
                              }
                            }
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isAnswerCorrect
                                    ? "Correct Answer!"
                                    : "Incorrect Answer!",
                              ),
                              backgroundColor: isAnswerCorrect
                                  ? Colors.green
                                  : Colors.redAccent,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Future.delayed(
                            Duration(seconds: 2),
                            () async {
                              nextQuestion();
                            },
                          );
                        },
                        child: const Text("Next"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          fixedSize: const Size(200, 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    timer = Timer(
      Duration(seconds: 1),
      () async {
        setState(() {
          _currentTimeInNanoSeconds -= 1000000000;
        });
        if (_currentTimeInNanoSeconds > 0) {
          startTimer();
        } else {
          var question =
              widget.papers[currentPaperIndex].questions[currentQuestionIndex];
          if (question.selectedAnswer.isEmpty) {
            question.selectedAnswer = "Not Answered";
          }
          double minutes = _currentTimeInNanoSeconds / 1000000000 / 60;
          double seconds = minutes % 60;
          widget.papers[currentPaperIndex].questions[currentQuestionIndex]
              .timeTaken = minutes + seconds;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Time's up!"),
            ),
          );

          nextQuestion();
        }
      },
    );
  }

  void cancelTimer() {
    timer?.cancel();
    timer = null;
  }

  void pauseTimer() {
    if (!_isTimerPaused) {
      // If timer is not already paused
      timer?.cancel();
      _isTimerPaused = true;
    }
  }

  void resumeTimer() {
    if (_isTimerPaused) {
      // If timer was paused
      startTimer(); // Restart the timer
      _isTimerPaused = false;
    }
  }

  Future<void> nextQuestion() async {
    isRed = false;
    isGreen = false;
    isBlue = false;
    isPink = false;

    redPressed = false;
    greenPressed = false;
    bluePressed = false;
    pinkPressed = false;

    levelOneColor = '';

    _isAllEnabled = false;

    Random random = Random();

    print("Question index is : " + currentQuestionIndex.toString());

    if ((currentPaperIndex == 0 && currentQuestionIndex == 0) ||
        (currentPaperIndex == 0 && currentQuestionIndex == 2) ||
        (currentPaperIndex == 0 && currentQuestionIndex == 4))
      levelOneColor = 'green';

    if ((currentPaperIndex == 0 && currentQuestionIndex == 1) ||
        (currentPaperIndex == 0 && currentQuestionIndex == 3))
      setState(() {
        levelOneColor = 'red';
      });

    if (currentPaperIndex == 1) {
      print("came inside here");
      int randomNumber = random.nextInt(colorNamesLevelTwo.length);
      levelTwoColor = colorNamesLevelTwo[randomNumber];
    }

    if (currentPaperIndex == 2) {
      Random random = Random();
      int randomNumber1 = random.nextInt(colorNamesLevelThree.length);

      // Generate the second random number until it is different from the first one
      int randomNumber2;
      do {
        randomNumber2 = random.nextInt(colorNamesLevelThree.length);
      } while (randomNumber2 == randomNumber1);

      levelThreeColorOne = colorNamesLevelThree[randomNumber1];
      levelThreeColorTwo = colorNamesLevelThree[randomNumber2];
    }

    if (currentPaperIndex + 1 == widget.papers.length &&
        currentQuestionIndex + 1 ==
            widget.papers[currentPaperIndex].questions.length) {
      cancelTimer();
      print("Going for results page");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Quiz Completed!"),
        ),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return EmotionDetectionFinalPage(
      //         papers: widget.papers,
      //       );
      //     },
      //   ),
      // );

      finalEmotion = findMostFrequent(myEmotionList);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ResultsPage(
              emotion: finalEmotion,
              papers: widget.papers,
            );
          },
        ),
      );

      return;
    }

    if (currentPaperIndex <= (widget.papers.length - 1)) {
      if (currentQuestionIndex <
          widget.papers[currentPaperIndex].questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          _currentTimeInNanoSeconds = TimePerQuizInNanoSeconds;
          // _isAllEnabled = true;
        });
      } else {
        setState(() {
          currentPaperIndex++;
          currentQuestionIndex = 0;
          _currentTimeInNanoSeconds = TimePerQuizInNanoSeconds;
          // _isAllEnabled = true;
        });
      }
      cancelTimer();
      if (widget.papers[currentPaperIndex].questions.isNotEmpty) {
        startTimer();
      }
    }
  }

  Future<void> _capturePhotoAndStore() async {
    print("came to capture method");

    // Ensure that cameras are available
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      print('No camera available');
      return;
    }

    // Select the first available camera
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first, // Fallback to the first available camera if no front camera is found
    );

    // Create a CameraController instance
    controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    // Initialize the camera controller
    await controller!.initialize();

    // Capture the image
    final XFile? capturedImg = await controller!.takePicture();

    // Dispose the camera controller
    // await controller.dispose();

    if (capturedImg == null) {
      print("Image capture failed");
      return;
    }

    // Continue with processing the captured image
    selectedImg = capturedImg;
    startTimer();
    await getTextFromImage();
  }

  Future<void> getTextFromImage() async {
    print("came to send method");
    try {
      // EasyLoading.show(status: "Loading...", dismissOnTap: false);
      var request = http.MultipartRequest(
          'POST', Uri.parse('$SERVER_CONNECTION_STRING/$ENDPOINT_IMAGE_TO_TEXT'));
      request.files
          .add(await http.MultipartFile.fromPath('file', selectedImg!.path));

      // Send the request
      var response = await request.send();

      // Read response as a string
      var responseData = await response.stream.bytesToString();

      // Check response status code
      if (response.statusCode == 200) {
        // Parse the JSON data
        var data = jsonDecode(responseData);
        var text = data['emotion'];
        print("The received emotion is : $text");
        myEmotionList.add(text);
      } else {
        print(response.statusCode);
        print(responseData);
        // Handle error response
        // showDialog(...); // Show error dialog if needed
      }

      // EasyLoading.dismiss();
    } catch (e) {
      // Handle exceptions
      // EasyLoading.dismiss();
      // ScaffoldMessenger.of(context).showSnackBar(...);
      print(e);
    }
  }

  String findMostFrequent(List<String> list) {
    // Create a map to store the frequency of each string
    Map<String, int> frequencyMap = {};

    // Iterate through the list and count occurrences
    for (String item in list) {
      frequencyMap[item] = (frequencyMap[item] ?? 0) + 1;
    }

    // Find the string with the highest count
    String mostFrequentString = '';
    int highestCount = 0;

    frequencyMap.forEach((key, value) {
      if (value > highestCount) {
        highestCount = value;
        mostFrequentString = key;
      }
    });

    return mostFrequentString;
  }
}
