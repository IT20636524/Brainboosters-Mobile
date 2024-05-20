import '../../models/mcq_option.dart';
import '../../models/mcq_paper.dart';
import '../../models/mcq_question.dart';
import '../enums/question_types.dart';

var problemSolving = MCQPaper(
  id: "MCQ-1",
  paperHeader: "Problem Solving",
  paperName: "Problem Solving",
  questions: List<MCQQuestion>.from([
    MCQQuestion(
      question: "Select the correct answer , 10 + 3 = ?",
      description: "",
      score: 1,
      type: QuestionType.problemSolving,
      options: List<MCQOption>.from([
        MCQOption(id: "a", answer: "assets/mcq_images/13.png", isCorrect: true),
        MCQOption(
            id: "b", answer: "assets/mcq_images/11.png", isCorrect: false),
        MCQOption(
            id: "c", answer: "assets/mcq_images/20.png", isCorrect: false),
        MCQOption(
            id: "d", answer: "assets/mcq_images/31.png", isCorrect: false),
      ]),
    ),
    MCQQuestion(
      question: "Select the correct answer , 2 x 5 = ?",
      description: "",
      score: 1,
      type: QuestionType.problemSolving,
      options: List<MCQOption>.from([
        MCQOption(
            id: "a", answer: "assets/mcq_images/31.png", isCorrect: false),
        MCQOption(
            id: "b", answer: "assets/mcq_images/20.png", isCorrect: false),
        MCQOption(id: "c", answer: "assets/mcq_images/10.png", isCorrect: true),
        MCQOption(
            id: "d", answer: "assets/mcq_images/40.png", isCorrect: false),
      ]),
    ),
    MCQQuestion(
      question: "Select the correct answer , 19 + 5 = ?",
      description: "",
      score: 1,
      type: QuestionType.problemSolving,
      options: List<MCQOption>.from([
        MCQOption(
            id: "a", answer: "assets/mcq_images/31.png", isCorrect: false),
        MCQOption(id: "b", answer: "assets/mcq_images/24.png", isCorrect: true),
        MCQOption(
            id: "c", answer: "assets/mcq_images/15.png", isCorrect: false),
        MCQOption(
            id: "d", answer: "assets/mcq_images/20.png", isCorrect: false),
      ]),
    ),
    MCQQuestion(
      question: "Select the correct answer , 12 x 3 = ?",
      description: "",
      score: 1,
      type: QuestionType.problemSolving,
      options: List<MCQOption>.from([
        MCQOption(
            id: "a", answer: "assets/mcq_images/40.png", isCorrect: false),
        MCQOption(
            id: "b", answer: "assets/mcq_images/20.png", isCorrect: false),
        MCQOption(id: "c", answer: "assets/mcq_images/36.png", isCorrect: true),
        MCQOption(
            id: "d", answer: "assets/mcq_images/15.png", isCorrect: false),
      ]),
    ),
    MCQQuestion(
      question: "Select the correct answer , 15 + 3 = ?",
      description: "",
      score: 1,
      type: QuestionType.problemSolving,
      options: List<MCQOption>.from([
        MCQOption(
            id: "a", answer: "assets/mcq_images/20.png", isCorrect: false),
        MCQOption(
            id: "b", answer: "assets/mcq_images/40.png", isCorrect: false),
        MCQOption(
            id: "c", answer: "assets/mcq_images/36.png", isCorrect: false),
        MCQOption(id: "d", answer: "assets/mcq_images/18.png", isCorrect: true),
      ]),
    ),
  ]),
);
