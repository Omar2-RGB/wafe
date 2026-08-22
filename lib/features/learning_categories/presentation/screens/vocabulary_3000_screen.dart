import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Vocabulary3000Screen extends StatefulWidget {
  final String categoryKey;
  final String categoryTitle;

  const Vocabulary3000Screen({
    Key? key,
    this.categoryKey = 'general',
    this.categoryTitle = 'الكلمات الشائعة',
  }) : super(key: key);

  @override
  State<Vocabulary3000Screen> createState() => _Vocabulary3000ScreenState();
}

class _Vocabulary3000ScreenState extends State<Vocabulary3000Screen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isLoading = true;
  List<Map<String, dynamic>> _words = [];

  @override
  void initState() {
    super.initState();
    _initTts();
    _fetchWords();
  }

  void _initTts() async {
    final prefs = await SharedPreferences.getInstance();
    double savedRate = prefs.getDouble('tts_speech_rate') ?? 0.45;
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(savedRate);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _fetchWords() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('vocabulary_3000')
          .select()
          .eq('category', widget.categoryKey) // 👈 جلب الكلمات الخاصة بهذا القسم فقط
          .order('word', ascending: true);

      setState(() {
        _words = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching words: $e");
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/app_logo.png', width: 28, height: 28, errorBuilder: (c, e, s) => const SizedBox()),
            const SizedBox(width: 8),
            Text(widget.categoryTitle, style: const TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)))
          : _words.isEmpty
              ? const Center(child: Text('لا توجد كلمات مضافة في هذا القسم حالياً', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: _words.length,
                    itemBuilder: (context, index) {
                      final wordData = _words[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!, width: 2),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF1CB0F6), size: 32),
                              onPressed: () async {
                                await _flutterTts.stop();
                                await _flutterTts.speak(wordData['word'] ?? '');
                              },
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wordData['word'] ?? '',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    wordData['meaning'] ?? '',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3C3C3C)),
                                  ),
                                  if (wordData['example'] != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      wordData['example'],
                                      style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}