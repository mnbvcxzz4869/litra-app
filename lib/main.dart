import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:litra/screens/navigation_bar.dart';

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

void main(){
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: theme,
      home: const NavigationBarScreen(),
    );
  }
}

