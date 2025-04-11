import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:litra/screens/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:litra/screens/navigation_bar.dart';
import 'package:litra/provider/firebase_user_provider.dart';
import 'firebase_options.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4272BA),
    brightness: Brightness.light,
    primary: Color(0xFF4272BA),
    secondary: Color(0xFFD9E3F3),
    tertiary: Color(0xFF95918B),
    surface: Color(0xFFFBF8F2),
    onSurface: Color(0xFF1D1E19),
  ),
  textTheme: GoogleFonts.literataTextTheme(),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFBF8F2),
    selectedItemColor: Color(0xFF4272BA),
    unselectedItemColor: Color(0xFF95918B),
  ),
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return MaterialApp(
      theme: theme,
      home: authState.when(
        data: (user) {
          if (user != null) {
            return const NavigationBarScreen();
          }
          return const LoginPage();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const LoginPage(),
      ),
    );
  }
}

