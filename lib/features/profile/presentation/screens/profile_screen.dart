import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  int _totalXp = 0;
  int _currentLevel = 0;
  int _streakCount = 0;
  int _hearts = 5;
  
  // إعدادات الصوت
  double _speechRate = 0.45; // القناة الافتراضية للسرعة
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _loadAudioSettings();
  }

  // جلب إحصائيات المستخدم الحقيقية من Supabase
  Future<void> _fetchUserProfile() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      
      if (user != null) {
        final response = await supabase
            .from('user_progress')
            .select()
            .eq('user_id', user.id)
            .maybeSingle();

        if (response != null) {
          setState(() {
            _totalXp = response['total_xp'] ?? 0;
            _currentLevel = response['current_level'] ?? 0;
            _streakCount = response['streak_count'] ?? 0;
            _hearts = response['hearts'] ?? 5;
          });
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // تحميل سرعة النطق المحفوظة محلياً
  Future<void> _loadAudioSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _speechRate = prefs.getDouble('tts_speech_rate') ?? 0.45;
    });
  }

  // حفظ وتغيير سرعة النطق
  Future<void> _updateSpeechRate(double rate) async {
    setState(() => _speechRate = rate);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tts_speech_rate', rate);
    
    // تجربة نطق تجريبية بالسرعة الجديدة
    await _flutterTts.setSpeechRate(rate);
    await _flutterTts.speak("Voice speed updated");
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
            const Text('الملف الشخصي والإحصائيات 👤', style: TextStyle(color: Color(0xFF3C3C3C), fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: const Color(0xFFF7F9FA), // 👈 مطابقة لون الـ AppBar مع الخلفية
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)))
          : RefreshIndicator(
              color: const Color(0xFF1CB0F6),
              onRefresh: _fetchUserProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // بطاقة المستخدم الترحيبية
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDF4FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF84D8FF), width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              width: 36,
                              height: 36,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person_rounded, size: 40, color: Color(0xFF1CB0F6)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('متعلم نشط', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6))),
                                SizedBox(height: 4),
                                Text('استمر في التعلم يومياً لتحافظ على تقدمك!', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // شبكة الإحصائيات المتقدمة (Stats Grid)
                    const Text('إحصائيات الأداء 📊', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
                    const SizedBox(height: 12),
                    
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard('مجموع النقاط (XP)', '$_totalXp ⚡', const Color(0xFFFFC800)),
                        _buildStatCard('المستوى الحالي', 'مستوى $_currentLevel 🎓', const Color(0xFF58CC02)),
                        _buildStatCard('أيام التمرس (Streak)', '$_streakCount أيام 🔥', const Color(0xFFFF9600)),
                        _buildStatCard('القلوب المتبقية', '$_hearts ❤️', const Color(0xFFFF4B4B)),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // قسم إعدادات الصوت وسرعة النطق 🔊
                    const Text('إعدادات الصوت والنطق 🎙️', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('سرعة النطق التلقائي (TTS Speed):', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF3C3C3C))),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('بطيء', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                              Text('${(_speechRate * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6))),
                              const Text('سريع', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Slider(
                            value: _speechRate,
                            min: 0.25,
                            max: 0.85,
                            divisions: 6,
                            activeColor: const Color(0xFF1CB0F6),
                            inactiveColor: Colors.grey[300],
                            onChanged: (value) => _updateSpeechRate(value),
                          ),
                          const Center(
                            child: Text(
                              'اسحب لتغيير سرعة نطق الكلمات والدروس بما يناسب فهمك',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // بطاقة إحصائيات مصممة بشكل أنيق
  Widget _buildStatCard(String title, String value, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 2),
        boxShadow: [BoxShadow(color: Colors.grey[100]!, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textColor)),
        ],
      ),
    );
  }
}