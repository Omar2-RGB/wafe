import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 1. الحالات (States)
abstract class LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<Map<String, dynamic>> topUsers;
  LeaderboardLoaded({required this.topUsers});
}

class LeaderboardError extends LeaderboardState {
  final String message;
  LeaderboardError(this.message);
}

// 2. الكيوبت (Cubit)
class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit() : super(LeaderboardLoading());

  Future<void> fetchLeaderboard() async {
    emit(LeaderboardLoading());

    try {
      final supabase = Supabase.instance.client;

      // جلب أعلى 10 مستخدمين ترتيباً تنازلياً بناءً على total_xp
      final response = await supabase
          .from('user_progress')
          .select('user_id, username, total_xp, current_level')
          .order('total_xp', ascending: false) // ترتيب تنازلي
          .limit(10); // جلب أعلى 10 فقط

      // تحويل النتيجة إلى قائمة يمكن استخدامها
      final List<Map<String, dynamic>> users = List<Map<String, dynamic>>.from(response);

      emit(LeaderboardLoaded(topUsers: users));
    } catch (e) {
      print("Error fetching leaderboard: $e");
      emit(LeaderboardError("حدث خطأ في جلب لوحة الصدارة"));
    }
  }
}