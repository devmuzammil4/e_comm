import 'dart:async';
import 'package:flutter/material.dart';
import 'package:e_comm/login_screen.dart';

void main() {
  // Play Store Rule: Global error boundary lagana taake framework errors handle hon aur app crash na ho
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Live app mein yahan crash reporting tool (jaise Firebase Crashlytics) ko error bhejte hain
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Enterprise',
      // Production Rule: Central light theme set karna taake pure app ke fonts aur colors global handle hon
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _startTimeout();
  }

  void _startTimeout() {
    // 3 second ka timer chalana login screen par jaane ke liye
    _splashTimer = Timer(const Duration(seconds: 3), _navigateToNextScreen);
  }

  void _navigateToNextScreen() {
    // Production Rule: Async gap ke baad context check karna compulsory hai taake memory leak ya background crash na ho
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    // Production Rule: Har active timer ko close/cancel karna lazmi hai, warna background memory kharab hoti rahegi
    _splashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Loading...",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
