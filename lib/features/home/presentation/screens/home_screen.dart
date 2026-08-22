import 'package:flutter/material.dart';
import 'package:gamified_english_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:gamified_english_app/features/exercise/presentation/screens/exercise_screen.dart';
import 'package:gamified_english_app/features/admin/presentation/screens/admin_screen.dart'; 
import 'package:gamified_english_app/features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:gamified_english_app/features/shop/presentation/screens/shop_screen.dart';
import 'package:gamified_english_app/features/learning_categories/presentation/screens/learning_categories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA), // 👈 خلفية عصرية ناعمة
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FA), // 👈 تم مطابقة لون الـ AppBar مع الخلفية ليزول البياض العلوي
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C), size: 32),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 32,
              height: 32,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
            const SizedBox(width: 8),
            const Text('W', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6))),
            const Text('afe', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
          ],
        ),
      ),
      
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFDDF4FF),
                border: Border(bottom: BorderSide(color: Color(0xFF84D8FF), width: 3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, color: Color(0xFF1CB0F6)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('W', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6))),
                      Text('afe English', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),

            _buildDrawerItem(
              context: context,
              icon: Icons.person_rounded,
              color: const Color(0xFF1CB0F6),
              title: 'الملف الشخصي',
              targetScreen: const ProfileScreen(),
            ),

            _buildDrawerItem(
              context: context,
              icon: Icons.leaderboard_rounded,
              color: const Color(0xFFFF9600),
              title: 'لوحة الصدارة',
              targetScreen: const LeaderboardScreen(),
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.storefront_rounded,
              color: const Color(0xFF1CB0F6),
              title: 'المتجر',
              targetScreen: const ShopScreen(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Divider(thickness: 2),
            ),

            _buildDrawerItem(
              context: context,
              icon: Icons.admin_panel_settings_rounded,
              color: Colors.grey[600]!,
              title: 'إدارة المحتوى',
              targetScreen: const AdminLoginScreen(),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              
              Center(
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF4FF),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF84D8FF), width: 4),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF1CB0F6).withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.school_rounded, size: 80, color: Color(0xFF1CB0F6)),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              
              const Text(
                'تعلم الإنجليزية بمتعة!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3C3C3C),
                ),
              ),
              const SizedBox(height: 12),
              
              // 👈 ضبط الاتجاهات ليعود النص بالترتيب الصحيح (العربية مع الإنجليزية)
              Directionality(
                textDirection: TextDirection.rtl,
                child: const Text(
                  'العب، تعلم، واجمع النقاط يومياً مع Wafe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              
              const Spacer(),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LearningCategoriesScreen()),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1CB0F6),
                    borderRadius: BorderRadius.circular(16),
                    border: const Border(
                      bottom: BorderSide(color: Color(0xFF1CB0F6), width: 6),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'ابدأ التعلم الآن 🚀',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required Widget targetScreen,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(icon, color: color, size: 32),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
      onTap: () {
        Navigator.pop(context); 
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
    );
  }
}