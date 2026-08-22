import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SectionContentsScreen extends StatefulWidget {
  final String subCategoryId;
  final String subCategoryTitle;

  const SectionContentsScreen({super.key, required this.subCategoryId, required this.subCategoryTitle});

  @override
  State<SectionContentsScreen> createState() => _SectionContentsScreenState();
}

class _SectionContentsScreenState extends State<SectionContentsScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isLoading = true;
  List<Map<String, dynamic>> _contents = [];

  @override
  void initState() {
    super.initState();
    _initTts();
    _fetchContents();
  }

  void _initTts() async {
    final prefs = await SharedPreferences.getInstance();
    double savedRate = prefs.getDouble('tts_speech_rate') ?? 0.45;
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(savedRate);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _fetchContents() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('section_contents')
          .select()
          .eq('sub_category_id', widget.subCategoryId);

      setState(() {
        _contents = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint("Error fetching contents: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: Text(widget.subCategoryTitle, style: const TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)))
          : _contents.isEmpty
              ? const Center(child: Text('لا توجد تفاصيل أو محتوى مضاف لهذا الصنف بعد', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: _contents.length,
                    itemBuilder: (context, index) {
                      final item = _contents[index];
                      
                      // 👈 معالجة النص واستبدال الـ \n النصية بأسطر حقيقية
                      String rawContent = item['content'] ?? '';
                      rawContent = rawContent.replaceAll(r'\n', '\n');
                      List<String> lines = rawContent.split('\n');

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[300]!, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['title'] ?? '',
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6)),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF1CB0F6), size: 30),
                                  onPressed: () async {
                                    await _flutterTts.stop();
                                    await _flutterTts.speak(item['title'] ?? '');
                                  },
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            // 👈 عرض كل سطر من الشرح أو القاعدة بشكل منفصل ومنظم
                            ...lines.map((line) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Text(
                                    line,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF3C3C3C)),
                                  ),
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}