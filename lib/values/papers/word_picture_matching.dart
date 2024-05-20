import '../../models/mcq_option.dart';
import '../../models/mcq_paper.dart';
import '../../models/mcq_question.dart';
import '../enums/question_types.dart';

var wordPictureMatching = MCQPaper(
  id: "MCQ-3",
  paperHeader: "Word Picture Matching",
  paperName: "Word Picture Matching",
  questions: List<MCQQuestion>.from([
    MCQQuestion(
      question: "Select the Apple ?",
      description: "",
      score: 1,
      type: QuestionType.wordPictureMatching,
      options: List<MCQOption>.from([
        MCQOption(
            id: "a", answer: "assets/mcq_images/apple.png", isCorrect: true),
        MCQOption(
            id: "b", answer: "assets/mcq_images/orange.png", isCorrect: false),
        MCQOption(
            id: "c",
            answer: "assets/mcq_images/watermelon.png",
            isCorrect: false),
        MCQOption(
            id: "d", answer: "assets/mcq_images/mango.png", isCorrect: false),
      ]),
    ),
    MCQQuestion(
      question: "Select the Elephant ?",
      description: "",
      score: 1,
      type: QuestionType.wordPictureMatching,
      options: List<MCQOption>.from([
        MCQOption(
            id: "a", answer: "assets/mcq_images/lion.png", isCorrect: false),
        MCQOption(
            id: "b", answer: "assets/mcq_images/dog.png", isCorrect: false),
        MCQOption(
            id: "c", answer: "assets/mcq_images/cat.png", isCorrect: false),
        MCQOption(
            id: "d", answer: "assets/mcq_images/elephant.png", isCorrect: true),
      ]),
    ),
    MCQQuestion(
      question: "Select the Rat ?",
      description: "",
      score: 1,
      type: QuestionType.wordPictureMatching,
      options: List<MCQOption>.from([
        MCQOption(
            id: "a", answer: "assets/mcq_images/lion.png", isCorrect: false),
        MCQOption(
            id: "b", answer: "assets/mcq_images/rat.jpeg", isCorrect: true),
        MCQOption(
            id: "c", answer: "assets/mcq_images/cat.png", isCorrect: false),
        MCQOption(
            id: "d", answer: "assets/mcq_images/dog.png", isCorrect: false),
      ]),
    ),
    MCQQuestion(
      question: "Select the Rabbit ? ",
      description: "",
      score: 1,
      type: QuestionType.wordPictureMatching,
      options: List<MCQOption>.from([
        MCQOption(
            id: "a",
            answer: "assets/mcq_images/elephant.png",
            isCorrect: false),
        MCQOption(
            id: "b", answer: "assets/mcq_images/rat.jpeg", isCorrect: false),
        MCQOption(
            id: "c", answer: "assets/mcq_images/cat.png", isCorrect: false),
        MCQOption(
            id: "d", answer: "assets/mcq_images/rabbit.jpeg", isCorrect: true),
      ]),
    ),
    MCQQuestion(
      question: "Select the Tiger ? ",
      description: "",
      score: 1,
      type: QuestionType.wordPictureMatching,
      options: List<MCQOption>.from([
        MCQOption(
            id: "a",
            answer: "assets/mcq_images/elephant.png",
            isCorrect: false),
        MCQOption(
            id: "b", answer: "assets/mcq_images/rat.jpeg", isCorrect: false),
        MCQOption(
            id: "c", answer: "assets/mcq_images/tiger.jpeg", isCorrect: true),
        MCQOption(
            id: "d", answer: "assets/mcq_images/rabbit.jpeg", isCorrect: false),
      ]),
    ),
  ]),
);
