import 'package:flutter/material.dart';
import 'package:listako/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:listako/views/theme/app_colors.dart';
import 'package:listako/views/auth/login_screen.dart';

// app entry
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ListaKoApp());
}

// app
class ListaKoApp extends StatelessWidget {
  const ListaKoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListaKo',
      debugShowCheckedModeBanner: false,

      
      // theme
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.green,
          primary: AppColors.green,
          secondary: AppColors.yellow,
          error: AppColors.red,
          surface: AppColors.white,
        ),
        // app bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.white,
        ),
        // input theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.green, width: 1.6),
          ),
        ),
        fontFamily: 'Poppins',
      ),

      
      // first screen
      home: const LoginScreen(),
    );
  }
}