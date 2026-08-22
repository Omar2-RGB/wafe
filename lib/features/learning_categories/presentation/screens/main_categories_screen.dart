import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sub_categories_screen.dart';

class MainCategoriesScreen extends StatefulWidget {
  const MainCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<MainCategoriesScreen> createState() => _MainCategoriesScreenState();
}

class _MainCategoriesScreenState extends State<MainCategoriesScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _mainCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchMainCategories();
  }

  Future<void> _fetchMainCategories() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.from('main_categories').select();
      setState(() {
        _mainCategories = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching main categories: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/app_logo.png', width: 28, height: 28, errorBuilder: (c, e, s) => const SizedBox()),
            const SizedBox(width: 8),
            const Text('الكورسات والأقسام المتقدمة 🌟', style: TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)))
          : _mainCategories.isEmpty
              ? const Center(child: Text('لا توجد أقسام رئيسية مضافة حالياً من لوحة التحكم', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _mainCategories.length,
                  itemBuilder: (context, index) {
                    final cat = _mainCategories[index];
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
                          decoration: BoxDecoration(color: const Color(0xFF1CB0F6).withOpacity(0.15), shape: BoxShape.circle),
                          child: const Icon(Icons.folder_special_rounded, color: Color(0xFF1CB0F6), size: 32),
                        ),
                        title: Text(cat['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
                        subtitle: const Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Text('اضغط لتصفح الأصناف والدروس التابعة', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubCategoriesScreen(
                                mainCategoryId: cat['id'].toString(),
                                mainCategoryTitle: cat['title'],
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