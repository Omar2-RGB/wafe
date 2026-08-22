// exercise_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/question_model.dart';

abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object> get props => [];
}

// 1. حالة التحميل (عند جلب الأسئلة من SQLite أو Supabase)
class ExerciseLoading extends ExerciseState {}

// 2. حالة النشاط (تُعرض عندما يكون المستخدم يفكر في السؤال)
class ExerciseActive extends ExerciseState {
  final Question currentQuestion;
  final int currentIndex;
  final int totalQuestions;
  final int hearts;

  const ExerciseActive({
    required this.currentQuestion,
    required this.currentIndex,
    required this.totalQuestions,
    required this.hearts,
  });

  @override
  List<Object> get props => [currentQuestion, currentIndex, totalQuestions, hearts];
}

// 3. حالة فحص الإجابة (تُعرض لحظة الضغط على "تأكيد" لعرض اللون الأخضر أو الأحمر)
class ExerciseAnswerChecked extends ExerciseState {
  final bool isCorrect;
  final String correctAnswer;
  final int currentHearts; // لإظهار نقص القلوب إذا كانت الإجابة خاطئة

  const ExerciseAnswerChecked({
    required this.isCorrect,
    required this.correctAnswer,
    required this.currentHearts,
  });

  @override
  List<Object> get props => [isCorrect, correctAnswer, currentHearts];
}

// 4. حالة انتهاء الدرس (لعرض شاشة الملخص والـ XP)
class ExerciseCompleted extends ExerciseState {
  final int earnedXP;
  final int remainingHearts;

  const ExerciseCompleted({
    required this.earnedXP,
    required this.remainingHearts,
  });

  @override
  List<Object> get props => [earnedXP, remainingHearts];
}