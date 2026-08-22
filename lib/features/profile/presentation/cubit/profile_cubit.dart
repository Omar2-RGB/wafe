import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ==== 1. الحالات (States) ====
abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String username;
  final int currentLevel;
  final int totalXp;
  final int hearts;

  ProfileLoaded({
    required this.username,
    required this.currentLevel,
    required this.totalXp,
    required this.hearts,
  });
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

// ==== 2. الكيوبت (Cubit) ====
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading());

  Future<void> fetchUserProfile() async {
    emit(ProfileLoading());

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        emit(ProfileError('المستخدم غير مسجل الدخول'));
        return;
      }

      // جلب بيانات المستخدم الحالي من قاعدة البيانات
      final response = await supabase
          .from('user_progress')
          .select('username, current_level, total_xp, hearts')
          .eq('user_id', user.id)
          .maybeSingle();

      if (response != null) {
        emit(ProfileLoaded(
          username: response['username'] ?? 'مستخدم مجهول',
          currentLevel: response['current_level'] as int,
          totalXp: response['total_xp'] as int,
          hearts: response['hearts'] as int,
        ));
      } else {
        emit(ProfileError('تعذر العثور على بيانات الحساب'));
      }
    } catch (e) {
      print("Error fetching profile: $e");
      emit(ProfileError("حدث خطأ في جلب بيانات الملف الشخصي"));
    }
  }

  // دالة تسجيل الخروج
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}