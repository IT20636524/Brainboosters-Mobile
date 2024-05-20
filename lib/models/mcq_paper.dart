import 'mcq_question.dart';

class MCQPaper {
  final String id;
  final String paperHeader;
  final String paperName;
  final List<MCQQuestion> questions;

  MCQPaper({
    required this.id,
    required this.paperHeader,
    required this.paperName,
    required this.questions,
  });

  get totalQuestions => questions.length;

  factory MCQPaper.fromJson(Map<String, dynamic> json) {
    return MCQPaper(
      id: json['id'],
      paperHeader: json['paperHeader'],
      paperName: json['paperName'],
      questions: json['questions']
          .map<MCQQuestion>((question) => MCQQuestion.fromJson(question))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paperHeader': paperHeader,
      'paperName': paperName,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  String toString() {
    return toJson().toString();
  }
}
