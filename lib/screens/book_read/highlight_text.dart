import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:litra/provider/highlight_provider.dart';
import 'package:litra/provider/reading_theme_provider.dart';

// Utility functions for text highlighting functionality

// Processes text taps to create or remove highlights at the tapped word location
void handleTextTapAccurate(
  TapUpDetails details, 
  String content, 
  List<HighlightRange> highlights,
  GlobalKey textKey,
  ReadingTheme readingTheme,
  WidgetRef ref,
  String chapterId,
  Color highlightColor,
) {
  try {
    final RenderObject? renderObj = textKey.currentContext?.findRenderObject();
    if (renderObj is! RenderParagraph) return;

    final RenderParagraph renderParagraph = renderObj;

    final Offset localPosition = renderParagraph.globalToLocal(details.globalPosition);
    final TextPosition textPosition = renderParagraph.getPositionForOffset(localPosition);
    final int tappedIndex = textPosition.offset;

    if (tappedIndex < 0 || tappedIndex >= content.length) return;

    final existingHighlight = highlights.firstWhere(
      (h) => h.start <= tappedIndex && h.end > tappedIndex,
      orElse: () => HighlightRange(-1, -1),
    );

    if (existingHighlight.start != -1) {
      ref.read(highlightProvider(chapterId).notifier).removeHighlight(existingHighlight);
    } else {
      final int wordStart = _findWordStart(content, tappedIndex);
      final int wordEnd = _findWordEnd(content, tappedIndex);

      final newHighlight = HighlightRange(wordStart, wordEnd, color: highlightColor);
      ref.read(highlightProvider(chapterId).notifier).addHighlight(newHighlight);
    }
  } catch (e) {
    debugPrint('Error handling text tap: $e');
  }
}

int _findWordStart(String content, int index) {
  while (index > 0 && content[index - 1] != ' ' && content[index - 1] != '\n') {
    index--;
  }
  return index;
}

int _findWordEnd(String content, int index) {
  while (index < content.length && content[index] != ' ' && content[index] != '\n') {
    index++;
  }
  return index;
}

// Constructs a list of TextSpans with appropriate highlighting for the content
List<TextSpan> buildHighlightedText(
  String content,
  List<HighlightRange> highlights,
  ReadingTheme readingTheme,
  Color highlightColor,
) {
  if (highlights.isEmpty) {
    return [
      TextSpan(
        text: content,
        style: GoogleFonts.getFont(
          readingTheme.fontFamily,
          fontSize: readingTheme.fontSize,
          height: readingTheme.lineHeight,
          letterSpacing: readingTheme.letterSpacing,
          fontWeight: readingTheme.fontWeight == 'Bold'
              ? FontWeight.bold
              : FontWeight.normal,
          color: readingTheme.fontColor,
        ),
      ),
    ];
  }

  final sortedHighlights = [...highlights]..sort((a, b) => a.start.compareTo(b.start));
  final spans = <TextSpan>[];
  int currentIndex = 0;

  for (final range in sortedHighlights) {
    if (currentIndex < range.start) {
      spans.add(TextSpan(
        text: content.substring(currentIndex, range.start),
        style: GoogleFonts.getFont(
          readingTheme.fontFamily,
          fontSize: readingTheme.fontSize,
          height: readingTheme.lineHeight,
          letterSpacing: readingTheme.letterSpacing,
          fontWeight: readingTheme.fontWeight == 'Bold'
              ? FontWeight.bold
              : FontWeight.normal,
          color: readingTheme.fontColor,
        ),
      ));
    }

    spans.add(TextSpan(
      text: content.substring(range.start, range.end),
      style: GoogleFonts.getFont(
        readingTheme.fontFamily,
        fontSize: readingTheme.fontSize,
        height: readingTheme.lineHeight,
        letterSpacing: readingTheme.letterSpacing,
        fontWeight: readingTheme.fontWeight == 'Bold'
            ? FontWeight.bold
            : FontWeight.normal,
        color: readingTheme.fontColor,
        backgroundColor: range.color ?? highlightColor,
      ),
    ));

    currentIndex = range.end;
  }

  if (currentIndex < content.length) {
    spans.add(TextSpan(
      text: content.substring(currentIndex),
      style: GoogleFonts.getFont(
        readingTheme.fontFamily,
        fontSize: readingTheme.fontSize,
        height: readingTheme.lineHeight,
        letterSpacing: readingTheme.letterSpacing,
        fontWeight: readingTheme.fontWeight == 'Bold'
            ? FontWeight.bold
            : FontWeight.normal,
        color: readingTheme.fontColor,
      ),
    ));
  }

  return spans;
}
