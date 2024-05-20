import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_pose_detection_example/pages/quiz_game_section/quiz_start_page.dart';

import '../../core/connection_strings.dart';
import '../../models/mcq_paper.dart';

class EmotionDetectionFinalPage extends StatefulWidget {
  final List<MCQPaper> papers;

  const EmotionDetectionFinalPage({Key? key, required this.papers})
      : super(key: key);

  @override
  State<EmotionDetectionFinalPage> createState() =>
      _EmotionDetectionFinalPageState();
}

class _EmotionDetectionFinalPageState extends State<EmotionDetectionFinalPage> {
  final ImagePicker picker = ImagePicker();
  XFile? selectedImage;
  int _selectedIndex = 0;
  String emotion = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  void showImageOptions() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Continue with this image?"),
          content: Image.file(
            File(selectedImage!.path),
            height: 400,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Retake"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                CroppedFile? croppedFile = await ImageCropper().cropImage(
                  sourcePath: selectedImage!.path,
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        lockAspectRatio: false),
                    IOSUiSettings(
                      title: 'Cropper',
                    ),
                    WebUiSettings(
                      context: context,
                    ),
                  ],
                );
                if (croppedFile != null) {
                  selectedImage = XFile(croppedFile.path);
                  showImageOptions();
                }
              },
              child: const Text("Crop"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }

  Future<void> getTextFromImage() async {
    try {
      EasyLoading.show(status: "Loading...", dismissOnTap: false);
      var request = http.MultipartRequest('POST',
          Uri.parse('$SERVER_CONNECTION_STRING/$ENDPOINT_IMAGE_TO_TEXT'));
      request.files
          .add(await http.MultipartFile.fromPath('file', selectedImage!.path));
      await request.send().then(
        (value) {
          if (value.statusCode == 200) {
            value.stream.transform(utf8.decoder).listen((value) {
              var data = jsonDecode(value);
              var text = data['emotion'];
              print("The received emotion is : $text");

              setState(() {
                emotion = text;
              });
              EasyLoading.dismiss();
            });
          } else {
            print(value.statusCode);
            EasyLoading.dismiss();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Upload Failed!"),
                  content:
                      const Text("Unable to upload image. Please try again."),
                  icon: const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Try Again"),
                    ),
                  ],
                );
              },
            );
          }
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to upload image. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: IndexedStack(
        index: _selectedIndex,
        children: [
          //index=0
          Center(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        tooltip: 'Back Icon',
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizStartPage()));
                        },
                      ),
                      Text(
                        "Emotion Check",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Image.asset(
                        'assets/images/profile_icon.png',
                        alignment: Alignment.center,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  "Check your current mood ........",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/camera_predict.png",
                        height: 100,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "How would you like to upload your photo ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilledButton.icon(
                            onPressed: () async {
                              selectedImage = await picker.pickImage(
                                  source: ImageSource.camera);
                              if (selectedImage != null) {
                                showImageOptions();
                              }
                            },
                            label: const Text("Camera"),
                            icon: const Icon(Icons.camera_rounded),
                          ),
                          FilledButton.icon(
                            onPressed: () async {
                              selectedImage = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (selectedImage != null) {
                                showImageOptions();
                              }
                            },
                            label: const Text("Gallery"),
                            icon: const Icon(Icons.image_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          //index=1
          if (selectedImage != null)
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          tooltip: 'Back Icon',
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuizStartPage()));
                          },
                        ),
                        Text(
                          "Emotion Check",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Image.asset(
                          'assets/images/profile_icon.png',
                          alignment: Alignment.center,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  selectedImage != null
                      ? Image.file(
                          File(selectedImage!.path),
                          height: 400,
                          fit: BoxFit.contain,
                        )
                      : const SizedBox(
                          height: 300,
                          width: 300,
                          child: Center(
                            child: Text("No image selected"),
                          ),
                        ),
                  const SizedBox(
                    height: 16,
                  ),
                  FilledButton.icon(
                    onPressed: () async {
                      setState(() {
                        selectedImage = null;
                        _selectedIndex = 0;
                      });
                    },
                    label: const Text("Remove Image"),
                    icon: const Icon(Icons.highlight_remove_rounded),
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: ElevatedButton(
                      onPressed: () async {
                        await getTextFromImage();
                        setState(() {
                          _selectedIndex = 2;
                        });

                        // var papers;
                        // papers = List<MCQPaper>.from(
                        //   [wordPictureMatching, problemSolving, logical],
                        // );
                        //
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => QuizPage(
                        //       papers: papers,
                        //     ),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        fixedSize: const Size(200, 40),
                      ),
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          Center(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        tooltip: 'Back Icon',
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizStartPage()));
                        },
                      ),
                      Text(
                        "Emotion Check",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Image.asset(
                        'assets/images/profile_icon.png',
                        alignment: Alignment.center,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  "Your current mood !",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 32,
                ),
                if (emotion == "happy")
                  Image.asset(
                    "assets/images/happy_face.jpeg",
                    height: 300,
                  ),
                if (emotion == "sad")
                  Image.asset(
                    "assets/images/sad_face.jpeg",
                    height: 300,
                  ),
                if (emotion == "angry")
                  Image.asset(
                    "assets/images/angry_face.jpeg",
                    height: 300,
                  ),
                if (emotion == "fear")
                  Image.asset(
                    "assets/images/fear_face.jpeg",
                    height: 300,
                  ),
                if (emotion == "disgust")
                  Image.asset(
                    "assets/images/disgust_face.jpeg",
                    height: 300,
                  ),
                if (emotion == "neutral")
                  Image.asset(
                    "assets/images/neutral_face.png",
                    height: 300,
                  ),
                if (emotion == "surprise")
                  Image.asset(
                    "assets/images/suprise_face.jpeg",
                    height: 300,
                  ),
                const SizedBox(
                  height: 64,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return ResultsPage(
                      //         emotion: emotion,
                      //         papers: widget.papers,
                      //       );
                      //     },
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      fixedSize: const Size(200, 40),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          )
          //index=2
        ],
      ),
    ));
  }
}
