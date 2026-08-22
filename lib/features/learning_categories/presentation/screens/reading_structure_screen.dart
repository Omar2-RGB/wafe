import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingStructureScreen extends StatefulWidget {
  const ReadingStructureScreen({Key? key}) : super(key: key);

  @override
  State<ReadingStructureScreen> createState() => _ReadingStructureScreenState();
}

class _ReadingStructureScreenState extends State<ReadingStructureScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isLoading = true;
  List<Map<String, dynamic>> _sentences = [];

  @override
  void initState() {
    super.initState();
    _initTts();
    _fetchSentences();
  }

  void _initTts() async {
    final prefs = await SharedPreferences.getInstance();
    double savedRate = prefs.getDouble('tts_speech_rate') ?? 0.45;
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(savedRate);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _fetchSentences() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('sentence_reading')
          .select()
          .order('level_index', ascending: true);
      setState(() {
        _sentences = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching sentences: $e");
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
            const Text('قراءة الجمل والتركيب ✍️', style: TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _sentences.length,
                itemBuilder: (context, index) {
                  final item = _sentences[index];
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
                          children: [
                            IconButton(
                              icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF1CB0F6), size: 30),
                              onPressed: () async {
                                await _flutterTts.stop();
                                await _flutterTts.speak(item['sentence_en'] ?? '');
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item['sentence_en'] ?? '',
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C)),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Text(
                          item['sentence_ar'] ?? '',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        if (item['grammar_tip'] != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDF4FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '💡 ${item['grammar_tip']}',
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1CB0F6)),
                            ),
                          ),
                        ]
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}