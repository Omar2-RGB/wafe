import 'package:flutter/material.dart';
import 'vocabulary_3000_screen.dart';

class VocabularyCategoriesScreen extends StatelessWidget {
  const VocabularyCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // قائمة الأقسام الفرعية للمفردات
    final List<Map<String, dynamic>> subCategories = [
      {'title': 'أعضاء الجسم', 'subtitle': 'تعلم أسماء أجزاء الجسم بالإنجليزية', 'key': 'body', 'icon': Icons.accessibility_new_rounded, 'color': const Color(0xFF1CB0F6)},
      {'title': 'الوقت والزمن', 'subtitle': 'الساعات، الأيام، الشهور والأشهر', 'key': 'time', 'icon': Icons.access_time_rounded, 'color': const Color(0xFFFF9600)},
      {'title': 'فصول السنة والطبيعة', 'subtitle': 'الطقس، الفصول، والعناصر الطبيعية', 'key': 'nature', 'icon': Icons.wb_sunny_rounded, 'color': const Color(0xFF58CC02)},
      {'title': 'المهن والوظائف', 'subtitle': 'أبرز المهن والأعمال اليومية', 'key': 'jobs', 'icon': Icons.work_rounded, 'color': const Color(0xFFCE82FF)},
      {'title': 'كلمات عامة (شاملة)', 'subtitle': 'الكلمات الشائعة العامة', 'key': 'general', 'icon': Icons.local_library_rounded, 'color': const Color(0xFF1CB0F6)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/app_logo.png', width: 28, height: 28, errorBuilder: (c, e, s) => const SizedBox()),
            const SizedBox(width: 8),
            const Text('أقسام المفردات 📚', style: TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          final subCat = subCategories[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!, width: 2),
              boxShadow: [BoxShadow(color: Colors.grey[200]!, offset: const Offset(0, 4))],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: (subCat['color'] as Color).withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(subCat['icon'], color: subCat['color'], size: 32),
              ),
              title: Text(subCat['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(subCat['subtitle'], style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Vocabulary3000Screen(
                      categoryKey: subCat['key'],
                      categoryTitle: subCat['title'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}