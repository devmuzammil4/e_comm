import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_comm/login_screen.dart';

void main() {
  // Global asynchronous errors ko catch karne ke liye safety zone wrapper
  runZonedGuarded(() async {
    // Native engine channels aur plugins ko run hone se pehle initialize karna lazmi hai
    WidgetsFlutterBinding.ensureInitialized();

    // Flutter UI layer/rendering tree mein aane wale exceptions ka interceptor
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };

    // Native platform level background tasks aur isolates ke crashes ko handle karne ka mechanism
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      debugPrint('Platform Error Catch Hua: $error');
      return true; // True batata hai ke crash handle ho chuka hai aur app dead nahi karni
    };

    // Production build mein framework ke crash hone par custom UI replacement trigger
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return const GlobalErrorScreen();
    };

    runApp(const MyApp());
  }, (Object error, StackTrace stackTrace) {
    // Kisi bhi kism ka bacha kucha uncaught error yahan zone boundary par catch hoga
    debugPrint('Zoned Exception: $error');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Top-level dependency injection tree jahan saare feature providers register hote hain
    return MultiProvider(
      providers : [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      // Dynamic listener framework jo notifications par child nodes ko rebuild karta hai
      child : Consumer <ThemeProvider>(
          builder : (context, themeProvider , child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'E-Commerce Enterprise',
              // Dynamic configuration routing switch for light/dark theme tracking
              themeMode: themeProvider.currentTheme,
              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.purple,
                  brightness: Brightness.light,
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.purple,
                  brightness: Brightness.dark,
                ),
              ),
              home: const SplashScreen(),
            );
          }
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Memory leaks se bachne ke liye lifecycle context tracking resource pointer
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _startTimeout();
  }

  void _startTimeout() {
    // 4 second ka safe timer fallback strategy sequence execution
    _splashTimer = Timer(const Duration(seconds: 4), _navigateToNextScreen);
  }

  void _navigateToNextScreen() {
    // Context lifecycle safety check taake screen background par leak na ho
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    // Active thread callbacks ki clean implementation aur resources storage flush
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

class GlobalErrorScreen extends StatelessWidget {
  const GlobalErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.redAccent,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Something Went Wrong",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "We are fixing this issue. Please try restarting the app.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Retry"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== THEME PROVIDER STATE MACHINE ====================
class ThemeProvider extends ChangeNotifier {
  // Private variable for core encapsulation guidelines management
  bool _isDarkMode = false;

  // External interface layer reading pipe gateway getter
  bool get isDarkMode => _isDarkMode;
  // Dynamic calculation token mapping theme object enum data standard
  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode; // Values invert mapping shortcut expression
    notifyListeners();          // Pure application render loop model update propagation signal
  }
}

// ==================== AUTH STATUS ENUM ====================
// Type-safe workflow classification options tracking variable index standard
enum AuthStatus { initial, loading, authenticated, unauthenticated }

// ==================== AUTH PROVIDER STATE MACHINE ====================
class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;

  AuthStatus get status => _status;
  // Inline shorthand verification variables calculation optimization flags
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> checkAuthStatus() async {
    // Network channel interface data fetching simulator delay latency trace
    await Future.delayed(const Duration(seconds: 2));
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void loginSuccess() {
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
