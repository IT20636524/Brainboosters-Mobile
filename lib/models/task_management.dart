class TaskManagementQuestion {
  final int id;
  final String title;
  final String question;
  final String category;
  final int points;
  final List<String> tasks;
  final List<String> answer;
  final int difficultyLevel;

  TaskManagementQuestion({
    required this.id,
    required this.title,
    required this.question,
    required this.category,
    required this.points,
    required this.tasks,
    required this.answer,
    required this.difficultyLevel,
  });

  factory TaskManagementQuestion.fromJson(Map<String, dynamic> json) {
    return TaskManagementQuestion(
      id: json['id'],
      title: json['title'],
      question: json['question'],
      category: json['category'],
      points: json['points'],
      tasks: List<String>.from(json['tasks']),
      answer: List<String>.from(json['answer']),
      difficultyLevel: json['difficultyLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'question': question,
      'category': category,
      'points': points,
      'tasks': tasks,
      'answer': answer,
      'difficultyLevel': difficultyLevel,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
