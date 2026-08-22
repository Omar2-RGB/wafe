import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ==== 1. الحالات (States) ====
abstract class ShopState {}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopLoaded extends ShopState {
  final int currentXp;
  final int currentHearts;
  ShopLoaded(this.currentXp, this.currentHearts);
}

class ShopActionSuccess extends ShopState {
  final String message;
  ShopActionSuccess(this.message);
}

class ShopActionError extends ShopState {
  final String message;
  ShopActionError(this.message);
}

// ==== 2. الكيوبت (Cubit) ====
class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(ShopInitial());

  // جلب النقاط والقلوب الحالية لعرضها في المتجر
  Future<void> fetchUserStats() async {
    emit(ShopLoading());
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase
          .from('user_progress')
          .select('total_xp, hearts')
          .eq('user_id', user.id)
          .single();

      emit(ShopLoaded(response['total_xp'] as int, response['hearts'] as int));
    } catch (e) {
      emit(ShopActionError("حدث خطأ في جلب بيانات المتجر"));
    }
  }

  // عملية شراء القلب
  Future<void> buyHeart() async {
    emit(ShopLoading()); // لإظهار دائرة تحميل أثناء الشراء
    
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // 1. قراءة البيانات الحالية
      final response = await supabase
          .from('user_progress')
          .select('total_xp, hearts')
          .eq('user_id', user.id)
          .single();

      int currentXp = response['total_xp'] as int;
      int currentHearts = response['hearts'] as int;
      const int heartCost = 50; // سعر القلب

      // 2. التحقق من الشروط
      if (currentHearts >= 5) {
        emit(ShopActionError('قلوبك ممتلئة بالفعل! (الحد الأقصى 5) ❤️'));
        fetchUserStats(); // تحديث الشاشة
        return;
      }

      if (currentXp < heartCost) {
        emit(ShopActionError('ليس لديك نقاط XP كافية! تحتاج إلى $heartCost نقطة ⚡'));
        fetchUserStats(); // تحديث الشاشة
        return;
      }

      // 3. خصم النقاط وإضافة القلب
      final newXp = currentXp - heartCost;
      final newHearts = currentHearts + 1;

      await supabase.from('user_progress').update({
        'total_xp': newXp,
        'hearts': newHearts,
      }).eq('user_id', user.id);

      // 4. إرسال حالة النجاح ثم تحديث الأرقام
      emit(ShopActionSuccess('تم شراء قلب بنجاح! 💖'));
      emit(ShopLoaded(newXp, newHearts));

    } catch (e) {
      emit(ShopActionError('حدث خطأ أثناء الشراء.'));
      fetchUserStats();
    }
  }
}