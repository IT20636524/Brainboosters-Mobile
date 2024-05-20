import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:learning_input_image/learning_input_image.dart';
import 'package:learning_pose_detection/learning_pose_detection.dart';
import 'package:learning_pose_detection/services/cache_service.dart';
import 'package:learning_pose_detection_example/models/exercise_instance_model.dart';
import 'package:learning_pose_detection_example/models/timer_provider.dart';
import 'package:learning_pose_detection_example/pages/fitness_analysis_section/final_results_page.dart';
import 'package:learning_pose_detection_example/pages/fitness_analysis_section/getting_started_page.dart';
import 'package:learning_pose_detection_example/pages/fitness_analysis_section/level_results_page.dart';
import 'package:learning_pose_detection_example/pages/home_page.dart';
import 'package:learning_pose_detection_example/pages/login_page.dart';
import 'package:learning_pose_detection_example/pages/quiz_game_section/quiz_start_page.dart';
import 'package:learning_pose_detection_example/pages/registration_page.dart';
import 'package:learning_pose_detection_example/theme/color_schemes.g.dart';
import 'package:learning_pose_detection_example/widgets/bottom_nav.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await _initPathProvider();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  runApp(MyApp());
}

Future<void> _initPathProvider() async {
  // Initialize path provider
  await getApplicationDocumentsDirectory();
}

class MyApp extends StatelessWidget {
  late final ExerciseInstance exerciseInstance;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PoseDetectionState()),
        ChangeNotifierProvider(create: (_) => TimerProvider(60)),
      ],
      child: MaterialApp(
        title: 'Posture App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        locale: const Locale('en', 'US'),
        themeMode: ThemeMode.light,
        routes: {
          HomePage.routeName: (context) =>
              HomePage(analytics: FirebaseAnalytics.instance),
          PoseDetectionPage.routeName: (context) => PoseDetectionPage(
                analytics: FirebaseAnalytics.instance,
                exerciseInstance: new ExerciseInstance(),
                selectedTime: "",
              ),
          FitnessAnalysisStartPage.routeName: (context) =>
              FitnessAnalysisStartPage(
                analytics: FirebaseAnalytics.instance,
                exerciseInstance: new ExerciseInstance(),
              ),
          BottomNavBar.routeName: (context) => BottomNavBar(),
          QuizStartPage.routeName: (context) => QuizStartPage(),
          LoginPage.routeName: (context) =>
              LoginPage(analytics: FirebaseAnalytics.instance),
          RegistrationPage.routeName: (context) =>
              RegistrationPage(analytics: FirebaseAnalytics.instance),
        },
        initialRoute: LoginPage.routeName,
        builder: EasyLoading.init(),
      ),
    );
  }
}

class PoseDetectionPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final ExerciseInstance exerciseInstance;
  final String selectedTime;

  const PoseDetectionPage(
      {Key? key,
      required this.analytics,
      required this.exerciseInstance,
      required this.selectedTime})
      : super(key: key);

  static String routeName = "/poseDetection";

  @override
  _PoseDetectionPageState createState() => _PoseDetectionPageState();
}

class _PoseDetectionPageState extends State<PoseDetectionPage> {
  PoseDetectionState get state => Provider.of(context, listen: false);
  PoseDetector _detector = PoseDetector(isStream: false);

  String timeLeftInMinutes = "0.00";
  int _seconds = 10;
  bool isDetectTimerDone = false;
  int timeLeftInSeconds = 0;
  int detectedPoseCount = 0;

  String? exerciseType = "";
  bool isTimerComplete = false;
  List<String> exerciseCountList = [];

  @override
  void dispose() {
    _detector.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    timeLeftInSeconds = widget.exerciseInstance.getCurrentExerciseTime();
    loadData();
    startExerciseDetectTimer();
  }

  Future<void> loadData() async {
    int? exCount = await getExerciseCount();
    print("Initial count is $exCount");
    if (exCount == null) {
      print("came to null if");
      await setExerciseCount(1);
    }
  }

  void startTimer() {
    Future.delayed(
      Duration(seconds: 1),
      () async {
        int timeLeftInSecondsNew = timeLeftInSeconds - 1;
        int timeLeftInMinutesNew = timeLeftInSeconds ~/ 60;
        setState(
          () {
            timeLeftInSeconds = timeLeftInSecondsNew;
            timeLeftInMinutes =
                "${timeLeftInMinutesNew.toString().padLeft(2, '0')}:${(timeLeftInSecondsNew % 60).toString().padLeft(2, '0')}";
          },
        );
        if (timeLeftInSeconds >= 0) {
          startTimer();
        } else {
          widget.analytics.logEvent(
              name: "pose_detection",
              parameters: {"pose_count": detectedPoseCount});

          int? exCount = await getExerciseCount();
          print("Count is $exCount");

          List<String> positionList = (await getExercisePositions());
          print("position list size : " + positionList.length.toString());
          print("position list//////");
          print(positionList);
          print("////////////////////////");

          if (exCount == 1) {
            print("came to 1");
            await setExerciseCount(2);
            await setLevelOnePositions(positionList);
            await removeExercisePositionsCache();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Completed !"),
                  content: Text(
                      "You have successfully completed the level one test,lets see your score and move onto level two"),
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.green,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevelResultsPage(
                              analytics: widget.analytics,
                              exerciseInstance: widget.exerciseInstance,
                              level: 'One',
                              positions: positionList,
                            ),
                          ),
                        );
                      },
                      child: Text("Proceed"),
                    ),
                  ],
                );
              },
            );
          } else if (exCount == 2) {
            print("came to 2");
            await setExerciseCount(3);
            await setLevelTwoPositions(positionList);
            await removeExercisePositionsCache();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Completed !"),
                  content: Text(
                      "You have successfully completed the level two test,lets see your score and move onto level three"),
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.green,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevelResultsPage(
                              analytics: widget.analytics,
                              exerciseInstance: widget.exerciseInstance,
                              level: 'Two',
                              positions: positionList,
                            ),
                          ),
                        );
                      },
                      child: Text("Proceed"),
                    ),
                  ],
                );
              },
            );
          } else if (exCount == 3) {
            print("came to 3");
            double levelScore = 0.0;
            await removeExCount();
            await setLevelThreePositions(positionList);

            const int totalMarks = 50;
            final correctSequence = [
              'Posture 4',
              'Posture 7',
              'Posture 2',
              'Posture 6',
              'Posture 1'
            ];
            final positions = removeExcessDuplicates(positionList);
            levelScore = calculateGrade(correctSequence, positions, totalMarks);
            print("Level three score is " + levelScore.toString());
            await setLevelThreeScore(levelScore);

            await removeExercisePositionsCache();
            print("Level 1 positions");
            print(getLevelOnePositions());
            print("Level 2 positions");
            print(getLevelTwoPositions());
            print("Level 3 positions");
            print(getLevelThreePositions());

            double levelOneScore = await getLevelOneScore();
            double levelTwoScore = await getLevelTwoScore();
            double levelThreeScore = await getLevelThreeScore();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Completed !"),
                  content: Text(
                      "You have successfully completed all three levels now ! , Lets see your results!"),
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.green,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FinalResultsPage(
                              analytics: widget.analytics,
                              exerciseInstance: widget.exerciseInstance,
                              levelOneScore: levelOneScore,
                              levelTwoScore: levelTwoScore,
                              levelThreeScore: levelThreeScore,
                            ),
                          ),
                        );
                      },
                      child: Text("Go to results page"),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
    );
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
      print("uniquePostures  Three positions are ");
      print(positions);
      print("////////////////////////////////////////////");
    }
    return uniquePostures;
  }

  void startExerciseDetectTimer() {
    Duration duration = Duration(seconds: 1);
    Timer.periodic(duration, (Timer timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          timer.cancel();
          isDetectTimerDone = true;
          startTimer();
        }
      });
    });
  }

  Future<void> _detectPose(InputImage image) async {
    if (state.isNotProcessing) {
      state.startProcessing();
      state.image = image;
      state.data = await _detector.detect(image);

      if (isTimerComplete == false) {
        getExercise();
      }

      setState(() {});
      state.stopProcessing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InputCameraView(
      cameraDefault: InputCameraType.rear,
      resolutionPreset: ResolutionPreset.veryHigh,
      title: 'Pose Detection',
      onImage: _detectPose,
      overlay: Consumer<PoseDetectionState>(
        builder: (_, state, __) {
          if (state.isEmpty) {
            return Container();
          }

          Size originalSize = state.size!;
          Size size = MediaQuery.of(context).size;

          // if image source from gallery
          // image display size is scaled to 360x360 with retaining aspect ratio
          if (state.notFromLive) {
            print("/////////////////////////////////////////////////");
            print("Pressed the button/////////////////");
            print("/////////////////////////////////////////////////");
            if (originalSize.aspectRatio > 1) {
              size = Size(360.0, 360.0 / originalSize.aspectRatio);
            } else {
              size = Size(360.0 * originalSize.aspectRatio, 360.0);
            }
          }

          return Stack(
            children: [
              PoseOverlay(
                size: size,
                originalSize: originalSize,
                rotation: state.rotation,
                pose: state.data!,
              ),
              Positioned(
                top: 60,
                right: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Exercise Time Left: " + timeLeftInMinutes + "m",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isDetectTimerDone == false
                  ? Positioned(
                      top: 110,
                      right: 10,
                      left: 10,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Starting exercise timer in: " +
                                    _seconds.toString() +
                                    "s",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Row(),
            ],
          );
        },
      ),
    );
  }

  Future<void> getExercise() async {
    await setTimer(isTimerComplete);
    await Future.delayed(Duration(seconds: 20)).then((value) async {
      exerciseType = (await getExerciseType());
      print("timer done///////////////////////////////////////////////////");
    });

    setState(() {
      isTimerComplete = true;
    });

    await setFinalExercise(exerciseType);
    await setTimer(isTimerComplete);
  }
}

class PoseDetectionState extends ChangeNotifier {
  InputImage? _image;
  Pose? _data;
  bool _isProcessing = false;

  InputImage? get image => _image;

  Pose? get data => _data;

  String? get type => _image?.type;

  InputImageRotation? get rotation => _image?.metadata?.rotation;

  Size? get size => _image?.metadata?.size;

  bool get isNotProcessing => !_isProcessing;

  bool get isEmpty => _data == null;

  bool get isFromLive => type == 'bytes';

  bool get notFromLive => !isFromLive;

  void startProcessing() {
    _isProcessing = true;
    notifyListeners();
  }

  void stopProcessing() {
    _isProcessing = false;
    notifyListeners();
  }

  set image(InputImage? image) {
    _image = image;

    if (notFromLive) {
      _data = null;
    }
    notifyListeners();
  }

  set data(Pose? data) {
    _data = data;
    notifyListeners();
  }
}
