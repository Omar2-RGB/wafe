import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // أضفنا استدعاء Supabase

// ==== 1. الحالات (States) ====
abstract class LearningPathState {}

class LearningPathLoading extends LearningPathState {}

class LearningPathLoaded extends LearningPathState {
  final int currentLevel;
  // أضفنا القلوب والنقاط لنتمكن من عرضها في الشريط العلوي لاحقاً
  final int hearts;
  final int totalXp;

  LearningPathLoaded({
    required this.currentLevel,
    required this.hearts,
    required this.totalXp,
  });
}

class LearningPathError extends LearningPathState {
  final String message;
  LearningPathError(this.message);
}

// ==== 2. الكيوبت (Cubit) ====
class LearningPathCubit extends Cubit<LearningPathState> {
  LearningPathCubit() : super(LearningPathLoading());

  Future<void> fetchUserProgress() async {
    emit(LearningPathLoading());
    
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      // التأكد من أن المستخدم مسجل الدخول
      if (user == null) {
        emit(LearningPathError('المستخدم غير مسجل الدخول'));
        return;
      }

      // جلب بيانات التقدم الخاصة بهذا المستخدم من قاعدة البيانات
      final response = await supabase
          .from('user_progress')
          .select('current_level, hearts, total_xp')
          .eq('user_id', user.id)
          .single(); // نستخدم single لأن كل مستخدم له صف واحد فقط

      // استخراج البيانات
      final int currentLevel = response['current_level'] as int;
      final int hearts = response['hearts'] as int;
      final int totalXp = response['total_xp'] as int;

      // إرسال البيانات الحقيقية للواجهة
      emit(LearningPathLoaded(
        currentLevel: currentLevel,
        hearts: hearts,
        totalXp: totalXp,
      )); 

    } catch (e) {
      print("Error fetching progress: $e");
      emit(LearningPathError('فشل في جلب البيانات. تأكد من اتصالك بالإنترنت.'));
    }
  }
}