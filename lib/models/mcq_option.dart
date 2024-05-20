class MCQOption {
  final String id;
  final String answer;
  final bool isCorrect;

  MCQOption({
    required this.id,
    required this.answer,
    required this.isCorrect,
  });

  factory MCQOption.fromJson(Map<String, dynamic> json) {
    return MCQOption(
      id: json['id'],
      answer: json['answer'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer': answer,
      'isCorrect': isCorrect,
    };
  }
}
