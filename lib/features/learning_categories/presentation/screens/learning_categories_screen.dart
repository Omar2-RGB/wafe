import 'package:flutter/material.dart';
import 'main_categories_screen.dart'; // شاشة الهيكل المتقدم للأقسام
import '../../../exercise/presentation/screens/exercise_screen.dart';
class LearningCategoriesScreen extends StatelessWidget {
  const LearningCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
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
            const Text('منصة التعلم 🎓', style: TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==========================================
            // البطاقة الكبرى: الكورسات والأقسام المتقدمة (كل المحتوى الديناميكي)
            // ==========================================
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainCategoriesScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1CB0F6), Color(0xFF0095E8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1CB0F6).withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star_rounded, color: Colors.white, size: 40),
                      ),
                      const Spacer(),
                      const Text(
                        'الكورسات والأقسام المتقدمة 🌟',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'تصفح الأرقام، الحروف، القواعد، ومحادثات المطار المضافة خصيصاً عبر لوحة التحكم مع النطق الصوتي والتنظيم الكامل.',
                        style: TextStyle(fontSize: 15, color: Colors.white70, fontWeight: FontWeight.bold, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          Text('ابدأ التعلم الآن', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            // ==========================================
            // البطاقة الثانية: زر الاختبارات والتمارين المنفصل
            // ==========================================
        Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  // 👈 الانتقال المباشر إلى شاشة التمارين والاختبارات
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExerciseScreen(
                      levelIndex: 1, // 👈 تمرير المستوى الإلزامي المطلوب
                    )),
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF58CC02), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF58CC02).withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF58CC02).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.quiz_rounded, color: Color(0xFF58CC02), size: 36),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'التحديات والاختبارات 🎯',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'اختبر معلوماتك في القواعد والكلمات واكسب النقاط',
                              style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}