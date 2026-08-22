import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/leaderboard_cubit.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaderboardCubit()..fetchLeaderboard(),
      child: Scaffold(
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
              const Text('لوحة الصدارة 🏆', style: TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          backgroundColor: const Color(0xFFF7F9FA), // 👈 مطابقة لون الـ AppBar مع الخلفية
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
        ),
        body: BlocBuilder<LeaderboardCubit, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)));
            }

            if (state is LeaderboardError) {
              return Center(child: Text(state.message, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF4B4B))));
            }

            if (state is LeaderboardLoaded) {
              final users = state.topUsers;

              if (users.isEmpty) {
                return const Center(child: Text("لا يوجد مستخدمون بعد!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final name = user['username'] ?? 'مستخدم ${user['user_id'].toString().substring(0, 5)}';
                  final xp = user['total_xp'];
                  final level = user['current_level'];

                  return _buildLeaderboardTile(index, name, xp, level);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLeaderboardTile(int index, String name, int xp, int level) {
    Color backgroundColor;
    Widget leadingWidget;

    if (index == 0) {
      backgroundColor = const Color(0xFFFFD700).withOpacity(0.2); // ذهبي
      leadingWidget = const Text('🥇', style: TextStyle(fontSize: 24));
    } else if (index == 1) {
      backgroundColor = const Color(0xFFC0C0C0).withOpacity(0.2); // فضي
      leadingWidget = const Text('🥈', style: TextStyle(fontSize: 24));
    } else if (index == 2) {
      backgroundColor = const Color(0xFFCD7F32).withOpacity(0.2); // برونزي
      leadingWidget = const Text('🥉', style: TextStyle(fontSize: 24));
    } else {
      backgroundColor = Colors.white;
      leadingWidget = Text('${index + 1}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(width: 40, alignment: Alignment.center, child: leadingWidget),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF3C3C3C))),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('مستوى $level', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$xp XP', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF58CC02), fontSize: 16)),
            const SizedBox(width: 4),
            const Icon(Icons.flash_on_rounded, color: Color(0xFFFF9600), size: 20),
          ],
        ),
      ),
    );
  }
}