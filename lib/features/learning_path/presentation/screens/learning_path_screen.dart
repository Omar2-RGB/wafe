import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../exercise/presentation/screens/exercise_screen.dart';
import '../cubit/learning_path_cubit.dart';

enum LessonState { completed, active, locked }

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LearningPathCubit()..fetchUserProgress(),
      child: BlocBuilder<LearningPathCubit, LearningPathState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F9FA), // 👈 خلفية عصرية موحدة
            appBar: state is LearningPathLoaded
                ? _buildGamifiedAppBar(state.hearts, state.totalXp)
                : _buildGamifiedAppBar(5, 0),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(LearningPathState state) {
    if (state is LearningPathLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)));
    }

    if (state is LearningPathError) {
      return Center(child: Text('حدث خطأ: ${state.message}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF4B4B))));
    }

    if (state is LearningPathLoaded) {
      return ListView.builder(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 40, bottom: 80),
        itemCount: 20,
        itemBuilder: (context, index) {
          LessonState lessonState;
          if (index < state.currentLevel) {
            lessonState = LessonState.completed;
          } else if (index == state.currentLevel) {
            lessonState = LessonState.active;
          } else {
            lessonState = LessonState.locked;
          }

          double alignmentX = math.sin(index * 0.8) * 0.5;
          return _buildPathNode(context, lessonState, index, alignmentX);
        },
      );
    }
    return const SizedBox();
  }

  PreferredSizeWidget _buildGamifiedAppBar(int hearts, int xp) {
    return AppBar(
      backgroundColor: const Color(0xFFF7F9FA), // 👈 مطابقة لون الـ AppBar مع الخلفية
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(color: Colors.grey[200], height: 2),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/app_logo.png',
                width: 28,
                height: 28,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.flag_rounded, color: Colors.blue),
              ),
              const SizedBox(width: 8),
              const Text('Wafe', style: TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFF9600), size: 28),
              const SizedBox(width: 4),
              Text('$xp', style: const TextStyle(color: Color(0xFFFF9600), fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.favorite_rounded, color: Color(0xFFFF4B4B), size: 28),
              const SizedBox(width: 4),
              Text('$hearts', style: const TextStyle(color: Color(0xFFFF4B4B), fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPathNode(BuildContext context, LessonState lessonState, int index, double alignmentX) {
    bool isCompleted = lessonState == LessonState.completed;
    bool isActive = lessonState == LessonState.active;

    Color buttonColor = isCompleted
        ? const Color(0xFFFFC800)
        : (isActive ? const Color(0xFF1CB0F6) : Colors.grey[300]!);
    Color shadowColor = isCompleted
        ? const Color(0xFFDCA900)
        : (isActive ? const Color(0xFF1CB0F6) : Colors.grey[400]!);
    IconData icon = isCompleted
        ? Icons.star_rounded
        : (isActive ? Icons.menu_book_rounded : Icons.lock_rounded);
    Color iconColor = (isCompleted || isActive) ? Colors.white : Colors.grey[500]!;

    return Align(
      alignment: Alignment(alignmentX, 0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                if (isActive || isCompleted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExerciseScreen(levelIndex: index)),
                  ).then((_) {
                    context.read<LearningPathCubit>().fetchUserProgress();
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: buttonColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: shadowColor, offset: const Offset(0, 6), blurRadius: 0),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 35),
              ),
            ),
            if (isActive)
              Positioned(
                top: -50,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: const Text(
                    'ابدأ',
                    style: TextStyle(color: Color(0xFF58CC02), fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}