import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ==========================================
// مساعد لتنسيق حقول الإدخال بلون موحد
// ==========================================
InputDecoration _buildInputDecoration(String label, {Widget? prefixIcon}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    prefixIcon: prefixIcon,
    prefixIconColor: Colors.white,
    filled: true,
    fillColor: const Color(0xFF1CB0F6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.white24, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.white, width: 2),
    ),
  );
}

const TextStyle _inputTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

// ==========================================
// 1. شاشة تسجيل الدخول للإدارة
// ==========================================
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _pinController = TextEditingController();
  final String _secretPin = "2026"; 
  String _errorMessage = "";

  void _verifyPin() {
    if (_pinController.text == _secretPin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboardScreen()));
    } else {
      setState(() => _errorMessage = "رمز المرور غير صحيح!");
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
            Image.asset(
              'assets/images/app_logo.png',
              width: 32,
              height: 32,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, color: Color(0xFF1CB0F6)),
            ),
            const SizedBox(width: 8),
            const Text('W', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6))),
            const Text('afe', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
            const Text(' • بوابة الإدارة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
        backgroundColor: const Color(0xFFF7F9FA), 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Color(0xFF3C3C3C)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF1CB0F6).withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(color: const Color(0xFF1CB0F6).withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.admin_panel_settings_rounded, size: 70, color: Color(0xFF1CB0F6)),
                const SizedBox(height: 16),
                const Text('تسجيل دخول المشرف', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
                const SizedBox(height: 24),
                TextField(
                  controller: _pinController, 
                  keyboardType: TextInputType.number, 
                  obscureText: true, 
                  textAlign: TextAlign.center, 
                  style: _inputTextStyle,
                  decoration: _buildInputDecoration('أدخل رمز المرور السري'),
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 12), 
                  Text(_errorMessage, style: const TextStyle(color: Color(0xFFFF4B4B), fontWeight: FontWeight.bold))
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1CB0F6), 
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ), 
                  onPressed: _verifyPin, 
                  child: const Text('دخول للنظام 🚀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. لوحة التحكم الرئيسية (8 تبويبات شاملة)
// ==========================================
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8, // 👈 8 تبويبات تغطي كل شيء في التطبيق إضافة وتعديل وحذف
      child: Scaffold(
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
              const Text('W', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
              const Text('afe', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white70)),
              const Text(' | لوحة التحكم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70)),
            ],
          ),
          backgroundColor: const Color(0xFF1CB0F6),
          elevation: 0,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            tabs: [
              Tab(icon: Icon(Icons.add_circle_outline), text: 'إضافة سؤال'),
              Tab(icon: Icon(Icons.edit_note_rounded), text: 'إدارة الأسئلة'),
              Tab(icon: Icon(Icons.menu_book_rounded), text: 'إضافة درس'),
              Tab(icon: Icon(Icons.list_alt_rounded), text: 'إدارة الدروس'),
              Tab(icon: Icon(Icons.library_add_rounded), text: 'كلمة مصنفة'),
              Tab(icon: Icon(Icons.category_rounded), text: 'إدارة المفردات'),
              Tab(icon: Icon(Icons.account_tree_rounded), text: 'هيكل متقدم'),
              Tab(icon: Icon(Icons.edit_road_rounded), text: 'إدارة الهيكل المتقدم'), // 👈 إدارة وتعديل وحذف محتوى الهيكل المتقدم
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddQuestionView(),
            ManageQuestionsView(),
            AddLessonView(),
            ManageLessonsView(),
            AddVocabularyView(),
            ManageVocabularyView(),
            AddHierarchicalContentView(),
            ManageHierarchicalContentView(), // 👈 عرض شاشة الإدارة للهيكل المتقدم
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. قسم إضافة سؤال جديد
// ==========================================
class AddQuestionView extends StatefulWidget {
  const AddQuestionView({Key? key}) : super(key: key);
  @override
  State<AddQuestionView> createState() => _AddQuestionViewState();
}

class _AddQuestionViewState extends State<AddQuestionView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final List<TextEditingController> _optionsControllers = List.generate(4, (index) => TextEditingController());
  String? _selectedCorrectAnswer;
  String _selectedQuestionType = 'vocabulary'; 
  bool _isLoading = false;

  Future<void> _uploadQuestion() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCorrectAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء تحديد الإجابة الصحيحة'), backgroundColor: Colors.red));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final options = _optionsControllers.map((c) => c.text).toList();
      String? imageUrl = _imageController.text.trim().isEmpty ? null : _imageController.text.trim();

      await Supabase.instance.client.from('questions').insert({
        'text': _questionController.text,
        'options': options,
        'correct_answer': _selectedCorrectAnswer,
        'level_index': int.tryParse(_levelController.text) ?? 0, 
        'image_url': imageUrl,
        'question_type': _selectedQuestionType,
      });

      _questionController.clear(); 
      _imageController.clear();
      for (var c in _optionsControllers) { c.clear(); }
      setState(() => _selectedCorrectAnswer = null);
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم إضافة السؤال بنجاح!'), backgroundColor: Colors.green));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _levelController, 
                      keyboardType: TextInputType.number, 
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('رقم المستوى'), 
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('قسم السؤال (التصنيف)'),
                      value: _selectedQuestionType,
                      items: const [
                        DropdownMenuItem(value: 'vocabulary', child: Text('📚 مفردات (Vocabulary)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'grammar', child: Text('📐 قواعد (Grammar)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'fill_in', child: Text('✍️ املأ الفراغات (Fill in the blanks)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'completion', child: Text('🧩 أكمل الجملة (Sentence Completion)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'listening', child: Text('🎧 تحدي الاستماع (Listening)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (value) => setState(() => _selectedQuestionType = value!),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _questionController, 
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('نص السؤال (بالإنجليزية للنطق التلقائي)'), 
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _imageController, 
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('رابط الصورة (اختياري)', prefixIcon: const Icon(Icons.image, color: Colors.white)),
                    ),
                    const SizedBox(height: 14),
                    ...List.generate(4, (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 14), 
                      child: TextFormField(
                        controller: _optionsControllers[index], 
                        style: _inputTextStyle,
                        decoration: _buildInputDecoration('الخيار ${index + 1}'), 
                        validator: (v) => v!.isEmpty ? 'مطلوب' : null, 
                        onChanged: (_) => setState((){}),
                      ),
                    )),
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('الإجابة الصحيحة'),
                      value: _selectedCorrectAnswer,
                      items: _optionsControllers.where((c) => c.text.isNotEmpty).map((c) => DropdownMenuItem(
                        value: c.text, 
                        child: Text(c.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )).toList(),
                      onChanged: (value) => setState(() => _selectedCorrectAnswer = value),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1CB0F6), 
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ), 
                      onPressed: _uploadQuestion, 
                      child: const Text('حفظ السؤال 🚀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ==========================================
// 4. قسم إدارة الأسئلة (تعديل وحذف)
// ==========================================
class ManageQuestionsView extends StatefulWidget {
  const ManageQuestionsView({Key? key}) : super(key: key);
  @override
  State<ManageQuestionsView> createState() => _ManageQuestionsViewState();
}

class _ManageQuestionsViewState extends State<ManageQuestionsView> {
  bool _isLoading = true;
  List<dynamic> _questions = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.from('questions').select().order('level_index', ascending: true);
      setState(() => _questions = response);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ في الجلب: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteQuestion(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا السؤال نهائياً؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      await Supabase.instance.client.from('questions').delete().eq('id', id);
      _fetchQuestions(); 
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحذف بنجاح', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)));
    if (_questions.isEmpty) return const Center(child: Text('لا توجد أسئلة حالياً', style: TextStyle(fontSize: 18, color: Colors.grey)));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: RefreshIndicator(
        color: const Color(0xFF1CB0F6),
        onRefresh: _fetchQuestions,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _questions.length,
          itemBuilder: (context, index) {
            final q = _questions[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(q['text'], style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('مستوى: ${q['level_index']} | القسم: ${q['question_type'] ?? 'vocabulary'} | الإجابة: ${q['correct_answer']}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, color: Color(0xFF1CB0F6)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditQuestionScreen(questionData: q)))
                             .then((_) => _fetchQuestions()); 
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, color: Color(0xFFFF4B4B)),
                      onPressed: () => _deleteQuestion(q['id'].toString()),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// 5. قسم إضافة درس تعليمي جديد
// ==========================================
class AddLessonView extends StatefulWidget {
  const AddLessonView({Key? key}) : super(key: key);

  @override
  State<AddLessonView> createState() => _AddLessonViewState();
}

class _AddLessonViewState extends State<AddLessonView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategoryType = 'vocabulary';
  bool _isLoading = false;

  Future<void> _uploadLesson() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.from('lessons').insert({
        'category_type': _selectedCategoryType,
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
      });

      _titleController.clear();
      _contentController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ تم إضافة الدرس بنجاح إلى قاعدة البيانات!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('القسم التعليمي'),
                      value: _selectedCategoryType,
                      items: const [
                        DropdownMenuItem(value: 'vocabulary', child: Text('📚 مفردات (Vocabulary)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'grammar', child: Text('📐 قواعد (Grammar)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'fill_in', child: Text('✍️ املأ الفراغات (Fill in the blanks)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'completion', child: Text('🧩 أكمل الجملة (Sentence Completion)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (value) => setState(() => _selectedCategoryType = value!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('عنوان الدرس أو الكلمة (بالإنجليزية - للنطق)'),
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 5,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('شرح الدرس والتفاصيل (بالعربية)'),
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF58CC02), 
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _uploadLesson,
                      child: const Text('حفظ ونشر الدرس 📚', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ==========================================
// 5.1 إدارة وتعديل وحذف الدروس
// ==========================================
class ManageLessonsView extends StatefulWidget {
  const ManageLessonsView({Key? key}) : super(key: key);
  @override
  State<ManageLessonsView> createState() => _ManageLessonsViewState();
}

class _ManageLessonsViewState extends State<ManageLessonsView> {
  bool _isLoading = true;
  List<dynamic> _lessons = [];

  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  Future<void> _fetchLessons() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.from('lessons').select().order('title', ascending: true);
      setState(() => _lessons = response);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ في الجلب: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteLesson(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا الدرس نهائياً؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      await Supabase.instance.client.from('lessons').delete().eq('id', id);
      _fetchLessons(); 
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف الدرس بنجاح', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)));
    if (_lessons.isEmpty) return const Center(child: Text('لا توجد دروس مضافة حالياً', style: TextStyle(fontSize: 18, color: Colors.grey)));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: RefreshIndicator(
        color: const Color(0xFF1CB0F6),
        onRefresh: _fetchLessons,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _lessons.length,
          itemBuilder: (context, index) {
            final l = _lessons[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(l['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('القسم: ${l['category_type']} | المحتوى: ${l['content']}', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, color: Color(0xFF1CB0F6)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditLessonScreen(lessonData: l)))
                             .then((_) => _fetchLessons()); 
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, color: Color(0xFFFF4B4B)),
                      onPressed: () => _deleteLesson(l['id'].toString()),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// 6. قسم إضافة كلمة مصنفة 
// ==========================================
class AddVocabularyView extends StatefulWidget {
  const AddVocabularyView({Key? key}) : super(key: key);

  @override
  State<AddVocabularyView> createState() => _AddVocabularyViewState();
}

class _AddVocabularyViewState extends State<AddVocabularyView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();
  
  String _selectedSubCategory = 'body'; 
  int _selectedLevel = 1;
  bool _isLoading = false;

  Future<void> _uploadVocabularyWord() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.from('vocabulary_3000').insert({
        'word': _wordController.text.trim(),
        'meaning': _meaningController.text.trim(),
        'example': _exampleController.text.trim().isEmpty ? null : _exampleController.text.trim(),
        'level': _selectedLevel,
        'category': _selectedSubCategory, 
      });

      _wordController.clear();
      _meaningController.clear();
      _exampleController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ تمت إضافة الكلمة المصنفة بنجاح!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('اختر الصنف الفرعي (الفئة)'),
                      value: _selectedSubCategory,
                      items: const [
                        DropdownMenuItem(value: 'body', child: Text('🧠 أعضاء الجسم (Body Parts)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'time', child: Text('⏰ الوقت والزمن (Time & Date)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'nature', child: Text('🌿 فصول السنة والطبيعة (Nature)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'jobs', child: Text('💼 المهن والوظائف (Jobs)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'general', child: Text('🌐 كلمات عامة (General)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (value) => setState(() => _selectedSubCategory = value!),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('المستوى (Level)'),
                      value: _selectedLevel,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('المستوى 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 2, child: Text('المستوى 2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 3, child: Text('المستوى 3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (value) => setState(() => _selectedLevel = value!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _wordController,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('الكلمة بالإنجليزية (للنطق الصوتي)'),
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _meaningController,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('المعنى بالعربية'),
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _exampleController,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('مثال توضيحي بالإنجليزية (اختياري)'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1CB0F6), 
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _uploadVocabularyWord,
                      child: const Text('حفظ الكلمة في القسم 📝', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ==========================================
// 6.1 إدارة وتعديل وحذف المفردات
// ==========================================
class ManageVocabularyView extends StatefulWidget {
  const ManageVocabularyView({Key? key}) : super(key: key);
  @override
  State<ManageVocabularyView> createState() => _ManageVocabularyViewState();
}

class _ManageVocabularyViewState extends State<ManageVocabularyView> {
  bool _isLoading = true;
  List<dynamic> _vocabulary = [];

  @override
  void initState() {
    super.initState();
    _fetchVocabulary();
  }

  Future<void> _fetchVocabulary() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.from('vocabulary_3000').select().order('word', ascending: true);
      setState(() => _vocabulary = response);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ في الجلب: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteVocabulary(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذه الكلمة نهائياً؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      await Supabase.instance.client.from('vocabulary_3000').delete().eq('id', id);
      _fetchVocabulary(); 
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف الكلمة بنجاح', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)));
    if (_vocabulary.isEmpty) return const Center(child: Text('لا توجد كلمات مضافة حالياً', style: TextStyle(fontSize: 18, color: Colors.grey)));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: RefreshIndicator(
        color: const Color(0xFF1CB0F6),
        onRefresh: _fetchVocabulary,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _vocabulary.length,
          itemBuilder: (context, index) {
            final v = _vocabulary[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(v['word'] ?? '', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6))),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('المعنى: ${v['meaning']} | القسم: ${v['category']} | مستوى: ${v['level']}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, color: Color(0xFF1CB0F6)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditVocabularyScreen(vocabData: v)))
                             .then((_) => _fetchVocabulary()); 
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, color: Color(0xFFFF4B4B)),
                      onPressed: () => _deleteVocabulary(v['id'].toString()),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// 7. قسم الهيكل التعليمي المتقدم (إضافة)
// ==========================================
class AddHierarchicalContentView extends StatefulWidget {
  const AddHierarchicalContentView({Key? key}) : super(key: key);

  @override
  State<AddHierarchicalContentView> createState() => _AddHierarchicalContentViewState();
}

class _AddHierarchicalContentViewState extends State<AddHierarchicalContentView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newMainCatController = TextEditingController();
  final TextEditingController _newSubCatController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  List<Map<String, dynamic>> _mainCategories = [];
  List<Map<String, dynamic>> _subCategories = [];
  
  String? _selectedMainCatId;
  String? _selectedSubCatId;
  String _selectedContentType = 'sentence';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMainCategories();
  }

  Future<void> _fetchMainCategories() async {
    setState(() => _isLoading = true);
    try {
      final res = await Supabase.instance.client.from('main_categories').select();
      setState(() {
        _mainCategories = List<Map<String, dynamic>>.from(res);
        if (_mainCategories.isNotEmpty) {
          _selectedMainCatId = _mainCategories.first['id'];
          _fetchSubCategories(_selectedMainCatId!);
        }
      });
    } catch (e) {
      print("Error fetching main categories: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchSubCategories(String mainCatId) async {
    try {
      final res = await Supabase.instance.client
          .from('sub_categories')
          .select()
          .eq('main_category_id', mainCatId);
      setState(() {
        _subCategories = List<Map<String, dynamic>>.from(res);
        _selectedSubCatId = _subCategories.isNotEmpty ? _subCategories.first['id'] : null;
      });
    } catch (e) {
      print("Error fetching sub categories: $e");
    }
  }

  Future<void> _addMainCategory() async {
    if (_newMainCatController.text.trim().isEmpty) return;
    try {
      final res = await Supabase.instance.client.from('main_categories').insert({
        'title': _newMainCatController.text.trim(),
      }).select().single();

      _newMainCatController.clear();
      await _fetchMainCategories();
      setState(() {
        _selectedMainCatId = res['id'];
        _fetchSubCategories(_selectedMainCatId!);
      });
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم إضافة القسم الرئيسي بنجاح'), backgroundColor: Colors.green));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _addSubCategory() async {
    if (_newSubCatController.text.trim().isEmpty || _selectedMainCatId == null) return;
    try {
      final res = await Supabase.instance.client.from('sub_categories').insert({
        'main_category_id': _selectedMainCatId,
        'title': _newSubCatController.text.trim(),
      }).select().single();

      _newSubCatController.clear();
      await _fetchSubCategories(_selectedMainCatId!);
      setState(() {
        _selectedSubCatId = res['id'];
      });
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم إضافة الصنف الفرعي بنجاح'), backgroundColor: Colors.green));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _saveContent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubCatId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار صنف فرعي أولاً'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.from('section_contents').insert({
        'sub_category_id': _selectedSubCatId,
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'type': _selectedContentType,
      });

      _titleController.clear();
      _contentController.clear();
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم إضافة المحتوى بنجاح!'), backgroundColor: Colors.green));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _mainCategories.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('1️⃣ اختر أو أضف قسماً رئيسياً', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF3C3C3C))),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('القسم الرئيسي'),
                      value: _selectedMainCatId,
                      items: _mainCategories.map((cat) => DropdownMenuItem(
                        value: cat['id'].toString(),
                        child: Text(cat['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedMainCatId = val;
                          _fetchSubCategories(val!);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _newMainCatController, style: _inputTextStyle, decoration: _buildInputDecoration('أضف قسم رئيسي جديد...'))),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF58CC02), padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    onPressed: _addMainCategory,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const Divider(height: 40, thickness: 2),

              const Text('2️⃣ اختر أو أضف صنفاً فرعياً', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF3C3C3C))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF1CB0F6),
                style: _inputTextStyle,
                decoration: _buildInputDecoration('الصنف الفرعي'),
                value: _selectedSubCatId,
                items: _subCategories.map((sub) => DropdownMenuItem(
                  value: sub['id'].toString(),
                  child: Text(sub['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )).toList(),
                onChanged: (val) => setState(() => _selectedSubCatId = val),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _newSubCatController, style: _inputTextStyle, decoration: _buildInputDecoration('أضف صنف فرعي جديد...'))),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF58CC02), padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    onPressed: _addSubCategory,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const Divider(height: 40, thickness: 2),

              const Text('3️⃣ أضف المحتوى التفصيلي (جمل، شرح، قواعد)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF3C3C3C))),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF1CB0F6),
                style: _inputTextStyle,
                decoration: _buildInputDecoration('نوع المحتوى'),
                value: _selectedContentType,
                items: const [
                  DropdownMenuItem(value: 'sentence', child: Text('✍️ جملة وقراءة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  DropdownMenuItem(value: 'grammar', child: Text('📐 قاعدة وشرح', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  DropdownMenuItem(value: 'vocab', child: Text('📚 مفردات', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ],
                onChanged: (val) => setState(() => _selectedContentType = val!),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _titleController,
                style: _inputTextStyle,
                decoration: _buildInputDecoration('العنوان أو النص الإنجليزي (للنطق الصوتي)'),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _contentController,
                maxLines: 4,
                style: _inputTextStyle,
                decoration: _buildInputDecoration('التفاصيل، الشرح، أو الترجمة بالعربية'),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58CC02),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _saveContent,
                child: const Text('حفظ المحتوى في الهيكل 🚀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 7.1 إدارة وتعديل وحذف محتوى الهيكل المتقدم (جديد)
// ==========================================
class ManageHierarchicalContentView extends StatefulWidget {
  const ManageHierarchicalContentView({Key? key}) : super(key: key);
  @override
  State<ManageHierarchicalContentView> createState() => _ManageHierarchicalContentViewState();
}

class _ManageHierarchicalContentViewState extends State<ManageHierarchicalContentView> {
  bool _isLoading = true;
  List<dynamic> _contents = [];

  @override
  void initState() {
    super.initState();
    _fetchContents();
  }

  Future<void> _fetchContents() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.from('section_contents').select().order('title', ascending: true);
      setState(() => _contents = response);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ في الجلب: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteContent(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا المحتوى نهائياً؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      await Supabase.instance.client.from('section_contents').delete().eq('id', id);
      _fetchContents(); 
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحذف بنجاح', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)));
    if (_contents.isEmpty) return const Center(child: Text('لا توجد محتويات متقدمة مضافة حالياً', style: TextStyle(fontSize: 18, color: Colors.grey)));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: RefreshIndicator(
        color: const Color(0xFF1CB0F6),
        onRefresh: _fetchContents,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _contents.length,
          itemBuilder: (context, index) {
            final c = _contents[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(c['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6))),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('النوع: ${c['type']} | التفاصيل: ${c['content']}', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, color: Color(0xFF1CB0F6)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditHierarchicalContentScreen(contentData: c)))
                             .then((_) => _fetchContents()); 
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, color: Color(0xFFFF4B4B)),
                      onPressed: () => _deleteContent(c['id'].toString()),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// 8. شاشة تعديل السؤال
// ==========================================
class EditQuestionScreen extends StatefulWidget {
  final Map<String, dynamic> questionData;
  const EditQuestionScreen({Key? key, required this.questionData}) : super(key: key);

  @override
  State<EditQuestionScreen> createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _levelController;
  late TextEditingController _questionController;
  late TextEditingController _imageController;
  late List<TextEditingController> _optionsControllers;
  String? _selectedCorrectAnswer;
  late String _selectedQuestionType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _levelController = TextEditingController(text: widget.questionData['level_index'].toString());
    _questionController = TextEditingController(text: widget.questionData['text']);
    _imageController = TextEditingController(text: widget.questionData['image_url'] ?? '');
    _selectedQuestionType = widget.questionData['question_type'] ?? 'vocabulary';
    
    _optionsControllers = List.generate(4, (index) => TextEditingController());
    List<dynamic> options = widget.questionData['options'];
    for(int i = 0; i < options.length; i++) {
      if(i < 4) _optionsControllers[i].text = options[i].toString();
    }
    
    _selectedCorrectAnswer = widget.questionData['correct_answer'];
  }

  Future<void> _updateQuestion() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCorrectAnswer == null) return;
    setState(() => _isLoading = true);
    
    try {
      final options = _optionsControllers.map((c) => c.text).toList();
      String? imageUrl = _imageController.text.trim().isEmpty ? null : _imageController.text.trim();

      await Supabase.instance.client.from('questions').update({
        'text': _questionController.text,
        'options': options,
        'correct_answer': _selectedCorrectAnswer,
        'level_index': int.tryParse(_levelController.text) ?? 0, 
        'image_url': imageUrl,
        'question_type': _selectedQuestionType,
      }).eq('id', widget.questionData['id']);

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم التعديل بنجاح!'), backgroundColor: Colors.green));
        Navigator.pop(context); 
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
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
            Image.asset(
              'assets/images/app_logo.png',
              width: 28,
              height: 28,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
            const SizedBox(width: 8),
            const Text('تعديل السؤال', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
          ],
        ),
        backgroundColor: const Color(0xFFFF9600),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9600))) 
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _levelController, 
                      keyboardType: TextInputType.number, 
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('رقم المستوى'), 
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('قسم السؤال (التصنيف)'),
                      value: _selectedQuestionType,
                      items: const [
                        DropdownMenuItem(value: 'vocabulary', child: Text('📚 مفردات (Vocabulary)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'grammar', child: Text('📐 قواعد (Grammar)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'fill_in', child: Text('✍️ املأ الفراغات (Fill in the blanks)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'completion', child: Text('🧩 أكمل الجملة (Sentence Completion)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'listening', child: Text('🎧 تحدي الاستماع (Listening)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (value) => setState(() => _selectedQuestionType = value!),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _questionController, 
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('نص السؤال'), 
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _imageController, 
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('رابط الصورة (اختياري)', prefixIcon: const Icon(Icons.image, color: Colors.white)),
                    ),
                    const SizedBox(height: 14),
                    ...List.generate(4, (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 14), 
                      child: TextFormField(
                        controller: _optionsControllers[index], 
                        style: _inputTextStyle,
                        decoration: _buildInputDecoration('الخيار ${index + 1}'), 
                        validator: (v) => v!.isEmpty ? 'مطلوب' : null, 
                        onChanged: (_) => setState((){}),
                      ),
                    )),
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('الإجابة الصحيحة'),
                      value: _selectedCorrectAnswer,
                      items: _optionsControllers.where((c) => c.text.isNotEmpty).map((c) => DropdownMenuItem(
                        value: c.text, 
                        child: Text(c.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )).toList(),
                      onChanged: (value) => setState(() => _selectedCorrectAnswer = value),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9600), 
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ), 
                      onPressed: _updateQuestion, 
                      child: const Text('تحديث السؤال 🔄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ==========================================
// 9. شاشة تعديل الدرس
// ==========================================
class EditLessonScreen extends StatefulWidget {
  final Map<String, dynamic> lessonData;
  const EditLessonScreen({Key? key, required this.lessonData}) : super(key: key);

  @override
  State<EditLessonScreen> createState() => _EditLessonScreenState();
}

class _EditLessonScreenState extends State<EditLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _selectedCategoryType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.lessonData['title'] ?? '');
    _contentController = TextEditingController(text: widget.lessonData['content'] ?? '');
    _selectedCategoryType = widget.lessonData['category_type'] ?? 'vocabulary';
  }

  Future<void> _updateLesson() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.from('lessons').update({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'category_type': _selectedCategoryType,
      }).eq('id', widget.lessonData['id']);

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم تعديل الدرس بنجاح!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text('تعديل الدرس', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        backgroundColor: const Color(0xFFFF9600),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9600)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('القسم التعليمي'),
                      value: _selectedCategoryType,
                      items: const [
                        DropdownMenuItem(value: 'vocabulary', child: Text('📚 مفردات (Vocabulary)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'grammar', child: Text('📐 قواعد (Grammar)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'fill_in', child: Text('✍️ املأ الفراغات', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'completion', child: Text('🧩 أكمل الجملة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (value) => setState(() => _selectedCategoryType = value!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('عنوان الدرس أو الكلمة'),
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 5,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('شرح الدرس والتفاصيل'),
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9600),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _updateLesson,
                      child: const Text('تحديث الدرس 🔄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ==========================================
// 10. شاشة تعديل الكلمة المصنفة
// ==========================================
class EditVocabularyScreen extends StatefulWidget {
  final Map<String, dynamic> vocabData;
  const EditVocabularyScreen({Key? key, required this.vocabData}) : super(key: key);

  @override
  State<EditVocabularyScreen> createState() => _EditVocabularyScreenState();
}

class _EditVocabularyScreenState extends State<EditVocabularyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _wordController;
  late TextEditingController _meaningController;
  late TextEditingController _exampleController;
  late String _selectedSubCategory;
  late int _selectedLevel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController(text: widget.vocabData['word'] ?? '');
    _meaningController = TextEditingController(text: widget.vocabData['meaning'] ?? '');
    _exampleController = TextEditingController(text: widget.vocabData['example'] ?? '');
    _selectedSubCategory = widget.vocabData['category'] ?? 'body';
    _selectedLevel = widget.vocabData['level'] ?? 1;
  }

  Future<void> _updateVocabulary() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.from('vocabulary_3000').update({
        'word': _wordController.text.trim(),
        'meaning': _meaningController.text.trim(),
        'example': _exampleController.text.trim().isEmpty ? null : _exampleController.text.trim(),
        'category': _selectedSubCategory,
        'level': _selectedLevel,
      }).eq('id', widget.vocabData['id']);

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم تعديل الكلمة بنجاح!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text('تعديل الكلمة المصنفة', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        backgroundColor: const Color(0xFFFF9600),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9600)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('اختر الصنف الفرعي'),
                      value: _selectedSubCategory,
                      items: const [
                        DropdownMenuItem(value: 'body', child: Text('🧠 أعضاء الجسم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'time', child: Text('⏰ الوقت والزمن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'nature', child: Text('🌿 فصول السنة والطبيعة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'jobs', child: Text('💼 المهن والوظائف', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'general', child: Text('🌐 كلمات عامة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (value) => setState(() => _selectedSubCategory = value!),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('المستوى'),
                      value: _selectedLevel,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('المستوى 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 2, child: Text('المستوى 2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 3, child: Text('المستوى 3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (value) => setState(() => _selectedLevel = value!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _wordController,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('الكلمة بالإنجليزية'),
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _meaningController,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('المعنى بالعربية'),
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _exampleController,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('مثال توضيحي (اختياري)'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9600),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _updateVocabulary,
                      child: const Text('تحديث الكلمة 🔄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ==========================================
// 11. شاشة تعديل محتوى الهيكل المتقدم
// ==========================================
class EditHierarchicalContentScreen extends StatefulWidget {
  final Map<String, dynamic> contentData;
  const EditHierarchicalContentScreen({Key? key, required this.contentData}) : super(key: key);

  @override
  State<EditHierarchicalContentScreen> createState() => _EditHierarchicalContentScreenState();
}

class _EditHierarchicalContentScreenState extends State<EditHierarchicalContentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _selectedContentType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.contentData['title'] ?? '');
    _contentController = TextEditingController(text: widget.contentData['content'] ?? '');
    _selectedContentType = widget.contentData['type'] ?? 'sentence';
  }

  Future<void> _updateContent() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.from('section_contents').update({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'type': _selectedContentType,
      }).eq('id', widget.contentData['id']);

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم التعديل بنجاح!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text('تعديل المحتوى المتقدم', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        backgroundColor: const Color(0xFFFF9600),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9600)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1CB0F6),
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('نوع المحتوى'),
                      value: _selectedContentType,
                      items: const [
                        DropdownMenuItem(value: 'sentence', child: Text('✍️ جملة وقراءة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'grammar', child: Text('📐 قاعدة وشرح', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'vocab', child: Text('📚 مفردات', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (value) => setState(() => _selectedContentType = value!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('العنوان أو النص الإنجليزي'),
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 5,
                      style: _inputTextStyle,
                      decoration: _buildInputDecoration('التفاصيل، الشرح أو الترجمة'),
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9600),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _updateContent,
                      child: const Text('تحديث المحتوى 🔄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}