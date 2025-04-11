import 'package:flutter/material.dart';
import 'package:litra/provider/reading_theme_provider.dart';

// A selectable color theme option for the reading screen

class ColorTheme extends StatelessWidget {
  const ColorTheme({
    super.key,
    required this.readingThemeNotifier,
    required this.backgroundColor,
    required this.fontColor,
  });

  final ReadingThemeNotifier readingThemeNotifier;
  final Color backgroundColor;
  final Color fontColor;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        readingThemeNotifier.updateField(fontColor: fontColor, backgroundColor: backgroundColor);
      },
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        child: Text('A', style: TextStyle(color: fontColor)),
      ),
    );
  }
}
