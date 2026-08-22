import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../home/presentation/screens/home_screen.dart'; // تأكد من مسار الشاشة الرئيسية

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // متحكم لاسم المستخدم
  final _usernameController = TextEditingController();
  
  bool _isLogin = true; 
  bool _isLoading = false;

  Future<void> _submitAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || (!_isLogin && username.isEmpty)) {
      _showMessage('الرجاء إدخال جميع البيانات المطلوبة', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      if (_isLogin) {
        // تسجيل الدخول
        await supabase.auth.signInWithPassword(email: email, password: password);
      } else {
        // إنشاء حساب جديد
        final response = await supabase.auth.signUp(email: email, password: password);
        
        if (response.user != null) {
          // حفظ اسم المستخدم في جدول التقدم
          await supabase.from('user_progress').insert({
            'user_id': response.user!.id,
            'username': username,
            'current_level': 0,
            'total_xp': 0,
            'hearts': 5,
          });
        }
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on AuthException catch (error) {
      _showMessage(error.message, isError: true);
    } catch (e) {
      _showMessage('حدث خطأ غير متوقع', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isError ? const Color(0xFFFF4B4B) : const Color(0xFF58CC02),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA), // 👈 خلفية عصرية موحدة
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              
              // عرض صورة اللوغو الحقيقية
              Center(
                child: Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF4FF),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF84D8FF), width: 3),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF1CB0F6).withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, size: 50, color: Color(0xFF1CB0F6)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // اسم البراند Wafe
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('W', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6))),
                  Text('afe', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
                ],
              ),
              const SizedBox(height: 10),

              Text(
                _isLogin ? 'أهلاً بك مجدداً!' : 'ابدأ رحلة التعلم!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // عرض حقل اسم المستخدم فقط عند إنشاء الحساب
              if (!_isLogin) ...[
                _buildTextField(
                  controller: _usernameController,
                  hint: 'اسم المستخدم (مثل: عمر)',
                  icon: Icons.face_rounded,
                ),
                const SizedBox(height: 16),
              ],

              _buildTextField(
                controller: _emailController,
                hint: 'البريد الإلكتروني',
                icon: Icons.email_rounded,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _passwordController,
                hint: 'كلمة المرور',
                icon: Icons.lock_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 32),

              GestureDetector(
                onTap: _isLoading ? null : _submitAuth,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: _isLoading ? Colors.grey[300] : const Color(0xFF1CB0F6),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _isLoading ? Colors.grey[400]! : const Color(0xFF1CB0F6),
                        offset: const Offset(0, 5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : Text(
                            _isLogin ? 'دخول' : 'إنشاء حساب',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin ? 'ليس لديك حساب؟ قم بإنشاء واحد' : 'لديك حساب بالفعل؟ سجل دخولك',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1CB0F6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1CB0F6), // 👈 خلفية حقل الإدخال أزرق مثل الشعار
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF84D8FF), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // 👈 نص أبيض بارز
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold), // 👈 تلميح أبيض ناعم
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}