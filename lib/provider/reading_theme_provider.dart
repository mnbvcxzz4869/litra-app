import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Models the customizable appearance settings for the book reading
class ReadingTheme {
  final String fontFamily;
  final String fontWeight;
  final double fontSize;
  final double lineHeight;
  final double letterSpacing;
  final TextAlign textAlign;
  final Color backgroundColor;
  final Color fontColor; 

  ReadingTheme({
    this.fontFamily = 'Literata',
    this.fontWeight = 'Regular',
    this.fontSize = 16,
    this.lineHeight = 1.5,
    this.letterSpacing = 0,
    this.textAlign = TextAlign.justify,
    this.backgroundColor = const Color(0xFFFBF8F2),
    this.fontColor = const Color(0xFF000000), 
  });

  ReadingTheme copyWith({
    String? fontFamily,
    String? fontWeight,
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
    TextAlign? textAlign,
    Color? backgroundColor,
    Color? fontColor, 
  }) {
    return ReadingTheme(
      fontFamily: fontFamily ?? this.fontFamily,
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      textAlign: textAlign ?? this.textAlign,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontColor: fontColor ?? this.fontColor, 
    );
  }
}

/// Provider for accessing and managing the reading theme settings
final readingThemeProvider = StateNotifierProvider<ReadingThemeNotifier, ReadingTheme>((ref) {
  return ReadingThemeNotifier();
});

class ReadingThemeNotifier extends StateNotifier<ReadingTheme> {
  ReadingThemeNotifier() : super(ReadingTheme());

  void updateTheme(ReadingTheme newTheme) {
    state = newTheme;
  }

  void updateField({
  String? fontFamily,
  String? fontWeight,
  double? fontSize,
  double? lineHeight,
  double? letterSpacing,
  TextAlign? textAlign,
  Color? backgroundColor,
  Color? fontColor, 
}) {
  state = state.copyWith(
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    fontSize: fontSize,
    lineHeight: lineHeight,
    letterSpacing: letterSpacing,
    textAlign: textAlign,
    backgroundColor: backgroundColor,
    fontColor: fontColor, 
  );
}
}