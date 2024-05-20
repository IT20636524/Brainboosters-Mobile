import '../values/enums/question_types.dart';
import 'mcq_option.dart';

class MCQQuestion {
  final String question;
  final String description;
  final int score;
  final QuestionType type;
  final List<MCQOption> options;

  String selectedAnswer = "";
  double timeTaken = 0.0;

  MCQQuestion({
    required this.question,
    required this.description,
    required this.score,
    required this.type,
    required this.options,
  });

  factory MCQQuestion.fromJson(Map<String, dynamic> json) {
    return MCQQuestion(
      question: json['question'],
      description: json['description'],
      score: json['score'],
      type: QuestionType.values[json['type']],
      options: json['options']
          .map<MCQOption>((option) => MCQOption.fromJson(option))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'description': description,
      'score': score,
      'type': type.index,
      'time': timeTaken,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }
}
