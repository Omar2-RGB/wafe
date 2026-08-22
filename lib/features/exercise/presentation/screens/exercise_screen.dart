import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/exercise_cubit.dart';
import '../cubit/exercise_state.dart';
import '../../domain/question_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseScreen extends StatelessWidget {
  final int levelIndex;
  final String? questionType; 
  
  const ExerciseScreen({Key? key, required this.levelIndex, this.questionType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ExerciseCubit();
        cubit.fetchQuestions(levelIndex, questionType: questionType); 
        return cubit;
      },
      child: const ExerciseView(),
    );
  }
}

class ExerciseView extends StatefulWidget {
  const ExerciseView({Key? key}) : super(key: key);

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  String? _selectedAnswer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts(); 
  
  Question? _activeQuestion; 
  String? _lastSpokenQuestionId;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    final prefs = await SharedPreferences.getInstance();
    double savedRate = prefs.getDouble('tts_speech_rate') ?? 0.45;

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(savedRate); 
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    try {
      _audioPlayer.dispose();
      _flutterTts.stop();
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA), // 👈 خلفية عصرية موحدة
      body: SafeArea(
        child: BlocConsumer<ExerciseCubit, ExerciseState>(
          listener: (context, state) {
            if (state is ExerciseAnswerChecked) {
              if (state.isCorrect) {
                _audioPlayer.play(AssetSource('sounds/correct.mp4'));
              } else {
                _audioPlayer.play(AssetSource('sounds/wrong.mp4'));
              }
            }
            if (state is ExerciseCompleted) {
              _showCompletionDialog(context, state.earnedXP, state.remainingHearts);
            }
          },
          builder: (context, state) {
            if (state is ExerciseLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF1CB0F6)));
            }

            Question? currentQuestion;
            double progress = 0;
            int hearts = 5;
            bool isChecked = false;
            bool isCorrect = false;

            if (state is ExerciseActive) {
              currentQuestion = state.currentQuestion;
              _activeQuestion = currentQuestion; 
              progress = state.currentIndex / state.totalQuestions;
              hearts = state.hearts;

              if (currentQuestion.questionType == 'listening' && _lastSpokenQuestionId != currentQuestion.id) {
                _lastSpokenQuestionId = currentQuestion.id;
                final nonNullQuestion = currentQuestion; 
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await _flutterTts.stop();
                  await _flutterTts.speak(nonNullQuestion.text);
                });
              }
            } else if (state is ExerciseAnswerChecked) {
              isChecked = true;
              isCorrect = state.isCorrect;
              hearts = state.currentHearts;
              currentQuestion = _activeQuestion; 
            }

            if (currentQuestion == null && !isChecked) return const SizedBox();

            bool isListeningMode = currentQuestion?.questionType == 'listening';

            return Column(
              children: [
                // شريط التمرير واللوغو العلوي
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          width: 28,
                          height: 28,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.close_rounded, color: Colors.grey, size: 28),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(height: 18, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10))),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 18,
                              width: MediaQuery.of(context).size.width * progress,
                              decoration: BoxDecoration(color: const Color(0xFF58CC02), borderRadius: BorderRadius.circular(10)),
                              child: Container(margin: const EdgeInsets.only(bottom: 6, left: 8, right: 8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(10))),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.favorite_rounded, color: Color(0xFFFF4B4B), size: 28),
                      const SizedBox(width: 6),
                      Text('$hearts', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFFFF4B4B))),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        
                        if (!isListeningMode && currentQuestion?.imageUrl != null && currentQuestion!.imageUrl!.isNotEmpty)
                          Container(
                            height: 200,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[300]!, width: 2),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              currentQuestion!.imageUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.broken_image_rounded, color: Colors.grey, size: 50));
                              },
                            ),
                          ),

                        isListeningMode
                            ? Container(
                                padding: const EdgeInsets.all(24),
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDDF4FF),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF84D8FF), width: 2),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.headphones_rounded, size: 60, color: Color(0xFF1CB0F6)),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'استمع جيداً للصوت واكتشف الكلمة:',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1CB0F6)),
                                    ),
                                    const SizedBox(height: 12),
                                    IconButton(
                                      icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF1CB0F6), size: 48),
                                      onPressed: () async {
                                        if (currentQuestion != null) {
                                          await _flutterTts.stop();
                                          await _flutterTts.speak(currentQuestion.text);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text('استمع وانطق الكلمة:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
                                  const SizedBox(height: 16),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 60, height: 60,
                                        decoration: BoxDecoration(color: Colors.amber[300], shape: BoxShape.circle, border: Border.all(color: Colors.amber[600]!, width: 2)),
                                        child: const Icon(Icons.face_retouching_natural, size: 40, color: Colors.white),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(4)),
                                            border: Border.all(color: Colors.grey[300]!, width: 2),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(currentQuestion?.text ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF3C3C3C))),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF1CB0F6), size: 32),
                                                onPressed: () async {
                                                  if (currentQuestion != null && currentQuestion.text.isNotEmpty) {
                                                    await _flutterTts.stop();
                                                    await _flutterTts.speak(currentQuestion.text);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        const SizedBox(height: 20),

                        if (currentQuestion != null)
                          ...currentQuestion.options.map((option) {
                            final isSelected = _selectedAnswer == option;
                            return GestureDetector(
                              onTap: isChecked ? null : () => setState(() => _selectedAnswer = option),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFDDF4FF) : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: isSelected ? const Color(0xFF84D8FF) : Colors.grey[300]!, width: 2),
                                  boxShadow: [BoxShadow(color: isSelected ? const Color(0xFF1CB0F6) : Colors.grey[300]!, offset: const Offset(0, 4), blurRadius: 0)],
                                ),
                                child: Text(option, style: TextStyle(fontSize: 18, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: isSelected ? const Color(0xFF1CB0F6) : const Color(0xFF4B4B4B))),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 32),
                  decoration: BoxDecoration(
                    color: !isChecked ? Colors.white : (isCorrect ? const Color(0xFFD7FFB8) : const Color(0xFFFFDFE0)),
                    border: Border(top: BorderSide(color: !isChecked ? Colors.grey[200]! : (isCorrect ? const Color(0xFF58CC02).withOpacity(0.3) : const Color(0xFFFF4B4B).withOpacity(0.3)), width: 2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isChecked) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: isCorrect ? const Color(0xFF58CC02).withOpacity(0.3) : const Color(0xFFFF4B4B).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]),
                              child: Icon(isCorrect ? Icons.check_rounded : Icons.close_rounded, color: isCorrect ? const Color(0xFF58CC02) : const Color(0xFFFF4B4B), size: 32),
                            ),
                            const SizedBox(width: 16),
                            Text(isCorrect ? 'رائع جداً!' : 'الإجابة الصحيحة هي:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: isCorrect ? const Color(0xFF58CC02) : const Color(0xFFFF4B4B))),
                          ],
                        ),
                        if (!isCorrect) ...[
                          const SizedBox(height: 8),
                          Text(currentQuestion?.correctAnswer ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF4B4B))),
                        ],
                        const SizedBox(height: 24),
                      ],
                      
                      GestureDetector(
                        onTap: _selectedAnswer == null
                            ? null
                            : () {
                                if (!isChecked) {
                                  context.read<ExerciseCubit>().checkAnswer(_selectedAnswer!);
                                } else {
                                  setState(() => _selectedAnswer = null);
                                  context.read<ExerciseCubit>().nextQuestion();
                                }
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: _getButtonColor(isChecked, isCorrect, _selectedAnswer != null),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: _getButtonShadowColor(isChecked, isCorrect, _selectedAnswer != null), offset: const Offset(0, 5), blurRadius: 0)],
                          ),
                          child: Center(
                            child: Text(isChecked ? 'متابعة' : 'تأكيد الإجابة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _selectedAnswer != null ? Colors.white : Colors.grey[400])),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Color _getButtonColor(bool isChecked, bool isCorrect, bool hasSelection) {
    if (!hasSelection) return Colors.grey[200]!;
    if (!isChecked) return const Color(0xFF58CC02);
    return isCorrect ? const Color(0xFF58CC02) : const Color(0xFFFF4B4B);
  }

  Color _getButtonShadowColor(bool isChecked, bool isCorrect, bool hasSelection) {
    if (!hasSelection) return Colors.grey[300]!;
    if (!isChecked) return const Color(0xFF1CB0F6);
    return isCorrect ? const Color(0xFF1CB0F6) : const Color(0xFFEA2B2B);
  }

  void _showCompletionDialog(BuildContext context, int xp, int hearts) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(child: Text('🎉 اكتمل الدرس!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFFFC800)))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('لقد ربحت $xp نقطة XP!', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('القلوب المتبقية: $hearts ❤️', style: const TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF58CC02), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(double.infinity, 50)),
            onPressed: () { Navigator.pop(context); Navigator.pop(context); },
            child: const Text('استمرار', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          )
        ],
      ),
    );
  }
}