import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'section_contents_screen.dart';

class SubCategoriesScreen extends StatefulWidget {
  final String mainCategoryId;
  final String mainCategoryTitle;

  const SubCategoriesScreen({Key? key, required this.mainCategoryId, required this.mainCategoryTitle}) : super(key: key);

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _subCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchSubCategories();
  }

  Future<void> _fetchSubCategories() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('sub_categories')
          .select()
          .eq('main_category_id', widget.mainCategoryId);

      setState(() {
        _subCategories = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching sub categories: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: Text(widget.mainCategoryTitle, style: const TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)))
          : _subCategories.isEmpty
              ? const Center(child: Text('لا توجد أصناف فرعية مضافة لهذا القسم بعد', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _subCategories.length,
                  itemBuilder: (context, index) {
                    final subCat = _subCategories[index];
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
                          decoration: BoxDecoration(color: const Color(0xFFCE82FF).withOpacity(0.15), shape: BoxShape.circle),
                          child: const Icon(Icons.menu_book_rounded, color: Color(0xFFCE82FF), size: 32),
                        ),
                        title: Text(subCat['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SectionContentsScreen(
                                subCategoryId: subCat['id'].toString(),
                                subCategoryTitle: subCat['title'],
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