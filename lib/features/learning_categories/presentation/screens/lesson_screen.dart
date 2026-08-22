import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gamified_english_app/features/exercise/presentation/screens/exercise_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // استيراد التخزين المحلي

class LessonScreen extends StatefulWidget {
  final String categoryType; 
  final String categoryTitle;

  const LessonScreen({Key? key, required this.categoryType, required this.categoryTitle}) : super(key: key);

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isLoading = true;
  List<Map<String, dynamic>> _lessons = [];

  @override
  void initState() {
    super.initState();
    _initTts(); // تهيئة النطق وسحب السرعة المحفوظة
    _fetchLessons();
  }

  // إعدادات النطق مع جلب السرعة المخصصة من الملف الشخصي
  void _initTts() async {
    final prefs = await SharedPreferences.getInstance();
    double savedRate = prefs.getDouble('tts_speech_rate') ?? 0.45;

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(savedRate); 
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  // جلب الدروس ديناميكياً من Supabase
  Future<void> _fetchLessons() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('lessons')
          .select()
          .eq('category_type', widget.categoryType);
      
      setState(() {
        _lessons = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching lessons: $e");
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
            Text('درس: ${widget.categoryTitle}', style: const TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: const Color(0xFFF7F9FA), // 👈 مطابقة لون الـ AppBar مع الخلفية
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '📖 اقرأ القاعدة والأمثلة جيداً واستمع للنطق قبل البدء بالتمرين:',
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _lessons.isEmpty
                        ? const Center(child: Text('لا توجد دروس مضافة لهذا القسم حالياً من لوحة التحكم', style: TextStyle(fontSize: 16, color: Colors.grey)))
                        : ListView.builder(
                            itemCount: _lessons.length,
                            itemBuilder: (context, index) {
                              final item = _lessons[index];
                              
                              String formattedContent = (item['content'] ?? '').toString().replaceAll('\\n', '\n');

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white, // بطاقات بيضاء تبرز فوق الخلفية العصرية
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey[300]!, width: 2),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF1CB0F6), size: 32),
                                      onPressed: () async {
                                        await _flutterTts.stop();
                                        await _flutterTts.speak(item['title'] ?? '');
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            item['title'] ?? '',
                                            textAlign: TextAlign.right,
                                            textDirection: TextDirection.ltr,
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6)),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            formattedContent,
                                            textAlign: TextAlign.right,
                                            textDirection: TextDirection.rtl,
                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF3C3C3C), height: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF58CC02),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseScreen(
                            levelIndex: 0,
                            questionType: widget.categoryType,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'أنا جاهز، ابدأ الاختبار! 🚀',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}