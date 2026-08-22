class Question {
  final String id;
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String? imageUrl;
  final String questionType; // 👈 التأكد من وجود نوع السؤال

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
    this.imageUrl,
    this.questionType = 'vocabulary',
  });
}