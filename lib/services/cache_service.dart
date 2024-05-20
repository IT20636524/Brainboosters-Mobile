import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future setCount(int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("count", value);
}

Future setExerciseType(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("exerciseType", value);
}

Future setTimer(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("timer", value);
}

Future setExerciseCount(int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("exerciseCount", value);
}

Future setFinalExercise(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("finalExercise", value);
}

Future<void> setExercises(List<String> stringList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> encodedList =
      stringList.map((string) => json.encode(string)).toList();
  await prefs.setStringList("threeExercises", encodedList);
}

Future<void> setThreeExerciseCounts(List<String> stringList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> encodedList =
      stringList.map((string) => json.encode(string)).toList();
  await prefs.setStringList("threeExerciseCounts", encodedList);
}

Future<void> setThreeExercises(List<String> stringList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> encodedList =
      stringList.map((string) => json.encode(string)).toList();
  await prefs.setStringList("threeExercisesNames", encodedList);
}

Future<void> setThreeExerciseTimers(List<String> stringList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> encodedList =
      stringList.map((string) => json.encode(string)).toList();
  await prefs.setStringList("threeExercisesTimers", encodedList);
}

Future<List<String>> getThreeExercisesTimers() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<dynamic>? encodedList = prefs.getStringList("threeExercisesTimers");
  if (encodedList != null) {
    List<String> stringList = encodedList
        .map((encodedString) => json.decode(encodedString))
        .cast<String>()
        .toList();
    return stringList;
  } else {
    return [];
  }
}

Future<List<String>> getThreeExercises() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<dynamic>? encodedList = prefs.getStringList("threeExercisesNames");
  if (encodedList != null) {
    List<String> stringList = encodedList
        .map((encodedString) => json.decode(encodedString))
        .cast<String>()
        .toList();
    return stringList;
  } else {
    return [];
  }
}

Future<List<String>> getThreeExerciseCounts() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<dynamic>? encodedList = prefs.getStringList("threeExerciseCounts");
  if (encodedList != null) {
    List<String> stringList = encodedList
        .map((encodedString) => json.decode(encodedString))
        .cast<String>()
        .toList();
    return stringList;
  } else {
    return [];
  }
}

Future<List<String>> getExercises() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<dynamic>? encodedList = prefs.getStringList("threeExercises");
  if (encodedList != null) {
    List<String> stringList = encodedList
        .map((encodedString) => json.decode(encodedString))
        .cast<String>()
        .toList();
    return stringList;
  } else {
    return [];
  }
}

Future<String?> getPosture() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("posturePosition")) {
    String? data = prefs.getString("posturePosition");
    return data;
  } else {
    return "";
  }
}

Future<String?> getExerciseType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("exerciseType")) {
    String? data = prefs.getString("exerciseType");
    return data;
  } else {
    return null;
  }
}

Future<bool?> getTimer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("timer")) {
    bool? data = prefs.getBool("timer");
    return data;
  } else {
    return null;
  }
}

Future<int?> getExerciseCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("exerciseCount")) {
    int? data = prefs.getInt("exerciseCount");
    return data;
  } else {
    return null;
  }
}

Future<String?> getFinalExercise() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("finalExercise")) {
    String? data = prefs.getString("finalExercise");
    return data;
  } else {
    return null;
  }
}

Future removeExercisePositionsCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("allExercisePos");
}

Future removeExerciseTypeCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("exerciseType");
}

Future removeTimerCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("timer");
}

Future removeExerciseCountCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("exerciseCount");
}

Future removeFinalExerciseCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("exercises");
}

Future removeExercisesCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("finalExercise");
}

Future removeThreeExercisesCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("threeExercises");
}

Future removeThreeExerciseCountCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("threeExerciseCounts");
}

Future removeThreeExerciseTimeCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("threeExercisesTimers");
}
