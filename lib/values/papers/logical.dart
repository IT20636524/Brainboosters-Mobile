import '../../models/mcq_option.dart';
import '../../models/mcq_paper.dart';
import '../../models/mcq_question.dart';
import '../enums/question_types.dart';

var logical = MCQPaper(
  id: "MCQ-2",
  paperHeader: "Logical",
  paperName: "Logical",
  questions: List<MCQQuestion>.from([
    MCQQuestion(
      question: "How many sides does a triangle have ?",
      description: "",
      score: 1,
      type: QuestionType.logical,
      options: List<MCQOption>.from([
        MCQOption(id: "a", answer: "assets/mcq_images/1.png", isCorrect: false),
        MCQOption(id: "b", answer: "assets/mcq_images/3.png", isCorrect: true),
        MCQOption(id: "c", answer: "assets/mcq_images/5.png", isCorrect: false),
        MCQOption(id: "d", answer: "assets/mcq_images/2.png", isCorrect: false),
      ]),
    ),
    MCQQuestion(
      question:
          "If you have 10 candies and you eat 3 of them, how many candies do you have left ?",
      description: "",
      score: 1,
      type: QuestionType.logical,
      options: List<MCQOption>.from([
        MCQOption(id: "a", answer: "assets/mcq_images/3.png", isCorrect: false),
        MCQOption(id: "b", answer: "assets/mcq_images/7.png", isCorrect: true),
        MCQOption(id: "c", answer: "assets/mcq_images/5.png", isCorrect: false),
        MCQOption(id: "d", answer: "assets/mcq_images/1.png", isCorrect: false),
      ]),
    ),
    MCQQuestion(
      question:
          "If you have 5 apples and you give 2 to your friend, how many apples do you have left ?",
      description: "",
      score: 1,
      type: QuestionType.logical,
      options: List<MCQOption>.from([
        MCQOption(id: "a", answer: "assets/mcq_images/2.png", isCorrect: false),
        MCQOption(id: "b", answer: "assets/mcq_images/5.png", isCorrect: false),
        MCQOption(id: "c", answer: "assets/mcq_images/3.png", isCorrect: true),
        MCQOption(id: "d", answer: "assets/mcq_images/1.png", isCorrect: false),
      ]),
    ),
    MCQQuestion(
      question:
          "If you have 8 marbles and you find 4 more, how many marbles do you have in total ?",
      description: "",
      score: 1,
      type: QuestionType.logical,
      options: List<MCQOption>.from([
        MCQOption(
            id: "a", answer: "assets/mcq_images/13.png", isCorrect: false),
        MCQOption(id: "b", answer: "assets/mcq_images/12.png", isCorrect: true),
        MCQOption(
            id: "c", answer: "assets/mcq_images/20.png", isCorrect: false),
        MCQOption(
            id: "d", answer: "assets/mcq_images/13.png", isCorrect: false),
      ]),
    ),
    MCQQuestion(
      question:
          "If you are playing with 6 toy cars and you put 2 away, how many toy cars are left to play with ?",
      description: "",
      score: 1,
      type: QuestionType.logical,
      options: List<MCQOption>.from([
        MCQOption(id: "a", answer: "assets/mcq_images/2.png", isCorrect: false),
        MCQOption(id: "b", answer: "assets/mcq_images/1.png", isCorrect: false),
        MCQOption(id: "c", answer: "assets/mcq_images/5.png", isCorrect: false),
        MCQOption(id: "d", answer: "assets/mcq_images/4.png", isCorrect: true),
      ]),
    ),
  ]),
);
