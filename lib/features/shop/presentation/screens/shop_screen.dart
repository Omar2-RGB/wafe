import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/shop_cubit.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit()..fetchUserStats(),
      child: const ShopView(),
    );
  }
}

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  void _showSnackBar(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isError ? const Color(0xFFFF4B4B) : const Color(0xFF58CC02),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA), // 👈 خلفية عصرية موحدة
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 28,
              height: 28,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
            const SizedBox(width: 8),
            const Text('المتجر 🏪', style: TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: const Color(0xFFF7F9FA), // 👈 مطابقة لون الـ AppBar مع الخلفية
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
      ),
      body: BlocConsumer<ShopCubit, ShopState>(
        listener: (context, state) {
          if (state is ShopActionSuccess) {
            _showSnackBar(context, state.message, false);
          } else if (state is ShopActionError) {
            _showSnackBar(context, state.message, true);
          }
        },
        buildWhen: (previous, current) => current is ShopLoaded || current is ShopLoading,
        builder: (context, state) {
          if (state is ShopLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)));
          }

          if (state is ShopLoaded) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // شريط الرصيد الحالي
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBalanceBadge(Icons.flash_on_rounded, '${state.currentXp}', const Color(0xFFFF9600)),
                      _buildBalanceBadge(Icons.favorite_rounded, '${state.currentHearts}', const Color(0xFFFF4B4B)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  
                  // بطاقة المنتج (القلب)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.grey[200]!, offset: const Offset(0, 6), blurRadius: 0),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.favorite_rounded, size: 80, color: Color(0xFFFF4B4B)),
                        const SizedBox(height: 16),
                        const Text('تعافي القلوب', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
                        const SizedBox(height: 8),
                        const Text(
                          'احصل على قلب إضافي لتتمكن من متابعة الدروس في حال أخطأت.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        
                        // زر الشراء
                        GestureDetector(
                          onTap: () => context.read<ShopCubit>().buyHeart(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1CB0F6),
                              borderRadius: BorderRadius.circular(16),
                              border: const Border(bottom: BorderSide(color: Color(0xFF1899D6), width: 4)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('شراء مقابل 50', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                                SizedBox(width: 8),
                                Icon(Icons.flash_on_rounded, color: Color(0xFFFFD700), size: 28),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBalanceBadge(IconData icon, String text, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: iconColor)),
        ],
      ),
    );
  }
}