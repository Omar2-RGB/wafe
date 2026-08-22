import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'exercise_state.dart';
import 'package:gamified_english_app/features/exercise/domain/question_model.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  ExerciseCubit() : super(ExerciseLoading());

  List<Question> _questions = [];
  int _currentIndex = 0;
  int _hearts = 5;
  int _xp = 0;
  int _playingLevelIndex = 0; 
Future<void> fetchQuestions(int levelIndex, {String? questionType}) async {
    _playingLevelIndex = levelIndex; 
    emit(ExerciseLoading());
    try {
      // بناء الاستعلام مع فلترة القسم إن وجد
      var query = Supabase.instance.client.from('questions').select().eq('level_index', levelIndex);
      
      if (questionType != null) {
        query = Supabase.instance.client.from('questions').select().eq('question_type', questionType);
      }

      final response = await query.limit(10); 
      final List<Question> fetchedQuestions = response.map((data) {
        return Question(
          id: data['id'].toString(),
          text: data['text'],
          options: List<String>.from(data['options']),
          correctAnswer: data['correct_answer'],
          imageUrl: data['image_url'], 
          questionType: data['question_type'] ?? 'vocabulary', // 👈 جلب النوع من القاعدة
        );
      }).toList();

      if (fetchedQuestions.isNotEmpty) {
        loadExercise(fetchedQuestions);
      } else {
        emit(ExerciseCompleted(earnedXP: 0, remainingHearts: _hearts));
      }
    } catch (e) {
      print("Error fetching questions: $e");
    }
  }
  void loadExercise(List<Question> questions) {
    _questions = questions; _currentIndex = 0; _hearts = 5; _xp = 0;
    if (_questions.isNotEmpty) _emitActiveState();
  }

  void checkAnswer(String userAnswer) {
    if (state is! ExerciseActive) return; 
    final currentQuestion = _questions[_currentIndex];
    final isCorrect = userAnswer == currentQuestion.correctAnswer;
    if (isCorrect) { _xp += 10; } else { _hearts -= 1; }
    emit(ExerciseAnswerChecked(isCorrect: isCorrect, correctAnswer: currentQuestion.correctAnswer, currentHearts: _hearts));
  }

  void nextQuestion() async {
    if (_hearts <= 0) {
      emit(ExerciseCompleted(earnedXP: _xp, remainingHearts: _hearts));
      return;
    }
    _currentIndex++;
    if (_currentIndex < _questions.length) {
      _emitActiveState();
    } else {
      emit(ExerciseLoading()); 
      await _saveProgressToSupabase();
      emit(ExerciseCompleted(earnedXP: _xp, remainingHearts: _hearts));
    }
  }

  Future<void> _saveProgressToSupabase() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase.from('user_progress').select('current_level, total_xp, streak_count, last_played_date').eq('user_id', user.id).maybeSingle();

      // حساب تاريخ اليوم
      final today = DateTime.now();
      final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      if (response != null) {
        int currentLevel = response['current_level'] as int;
        int currentXp = response['total_xp'] as int;
        int currentStreak = response['streak_count'] ?? 0;
        String? lastPlayed = response['last_played_date'];

        // ==== حساب الشعلة 🔥 ====
        int newStreak = currentStreak;
        if (lastPlayed != todayStr) {
          if (lastPlayed != null) {
            final lastDate = DateTime.parse(lastPlayed);
            final difference = DateTime.parse(todayStr).difference(lastDate).inDays;
            if (difference == 1) {
              newStreak++; // لعب في اليوم التالي مباشرة (يستمر)
            } else if (difference > 1) {
              newStreak = 1; // خسر الشعلة وبدأ من جديد
            }
          } else {
            newStreak = 1; // أول مرة يلعب
          }
        }

        int newLevel = currentLevel;
        if (_playingLevelIndex >= currentLevel) newLevel = currentLevel + 1;

        await supabase.from('user_progress').update({
          'current_level': newLevel,
          'total_xp': currentXp + _xp,
          'hearts': _hearts,
          'streak_count': newStreak,
          'last_played_date': todayStr,
        }).eq('user_id', user.id);
      }
    } catch (e) {
      print("Error saving progress: $e");
    }
  }

  void _emitActiveState() {
    emit(ExerciseActive(currentQuestion: _questions[_currentIndex], currentIndex: _currentIndex, totalQuestions: _questions.length, hearts: _hearts));
  }
}