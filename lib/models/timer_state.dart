import 'dart:async';

class TimerState {
  late Timer _timer;
  late int _elapsedSeconds;
  late int _totalSeconds;

  TimerState(int totalSeconds) {
    _elapsedSeconds = 0;
    _totalSeconds = totalSeconds;
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_elapsedSeconds < _totalSeconds) {
          _elapsedSeconds++;
        } else {
          timer.cancel(); // Stop the timer when it's elapsed
        }
      },
    );
  }

  void updateElapsedTime(int seconds) {
    _elapsedSeconds = seconds;
  }

  int get elapsedSeconds => _elapsedSeconds;

  int get totalSeconds => _totalSeconds;

  void dispose() {
    _timer.cancel();
  }

  // Define the startTimer method
  void startTimer() {
    _startTimer();
  }
}
