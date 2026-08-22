import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gamified_english_app/features/home/presentation/screens/home_screen.dart'; 
// يمكنك إزالة استدعاء ExerciseScreen من هنا لأننا استدعيناه داخل HomeScreen
import 'package:gamified_english_app/features/auth/presentation/screens/auth_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://jwkwpqihduwaxzvamqai.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp3a3dwcWloZHV3YXh6dmFtcWFpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODcyNTU2MDIsImV4cCI6MjEwMjgzMTYwMn0.Opi4Gbqg25x-CsxG3c7R_NKCdCmV78DSsIAiQpfHu7M',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wafe',
      theme: ThemeData(
        fontFamily: 'Tajawal', 
        primarySwatch: Colors.green,
      ),
      // جعلنا الشاشة الرئيسية هي واجهة البداية
    home: Supabase.instance.client.auth.currentUser == null
          ? const AuthScreen()
          : const HomeScreen(), // إذا كان مسجل دخول، يدخل للرئيسية مباشرة، وإلا يذهب لشاشة الدخول
    );
  }
}