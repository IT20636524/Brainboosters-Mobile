import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learning_pose_detection_example/models/timer_state.dart';

class TimerProvider extends ChangeNotifier {
  late TimerState _timerState;
  late Timer _timer;

  TimerProvider(int totalSeconds) {
    _timerState = TimerState(totalSeconds);
    _timerState.startTimer();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _timerState.updateElapsedTime(1);
      notifyListeners();
    });
  }

  TimerState get timerState => _timerState;

  int get elapsedSeconds => _timerState.elapsedSeconds;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
