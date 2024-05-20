class ExerciseInstance {
  bool isExerciseOneDone = false;
  bool isExerciseTwoDone = false;
  bool isExerciseThreeDone = false;
  int currentStep = 0;
  int exerciseTime = 0;
  int exerciseOnePoseCount = 0;
  int exerciseTwoPoseCount = 0;
  int exerciseThreePoseCount = 0;

  goToNextStep() {
    currentStep = currentStep + 1;
  }

  setCurrentExerciseTime(int time) {
    exerciseTime = time;
  }

  setExerciseOneDone(int poseCount) {
    exerciseOnePoseCount = poseCount;
    isExerciseOneDone = true;
  }

  setExerciseTwoDone(int poseCount) {
    exerciseOnePoseCount = poseCount;
    isExerciseOneDone = true;
  }

  setExerciseThreeDone(int poseCount) {
    exerciseOnePoseCount = poseCount;
    isExerciseOneDone = true;
  }

  int getCurrentStepId() {
    return currentStep;
  }

  String getCurrentStepName() {
    if (currentStep == 0) {
      return "Squat";
    } else if (currentStep == 1) {
      return "Inner tie and oblique";
    } else if (currentStep == 2) {
      return "Side Static Luge";
    }else {
      return "Getting Started";
    }
  }

  int getCurrentExerciseTime() {
    return exerciseTime;
  }

  bool getExerciseOneDone() {
    return isExerciseOneDone;
  }

  bool getExerciseTwoDone() {
    return isExerciseTwoDone;
  }

  bool getExerciseThreeDone() {
    return isExerciseThreeDone;
  }

  int getExerciseOnePoseCount() {
    return exerciseOnePoseCount;
  }

  int getExerciseTwoPoseCount() {
    return exerciseOnePoseCount;
  }

  int getExerciseThreePoseCount() {
    return exerciseOnePoseCount;
  }
}
