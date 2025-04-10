import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighlightRange {
  final int start;
  final int end;
  final Color? color;

  HighlightRange(this.start, this.end, {this.color});

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'color': color != null ? _colorToString(color!) : null,
    };
  }

  factory HighlightRange.fromJson(Map<String, dynamic> json) {
    return HighlightRange(
      json['start'] as int,
      json['end'] as int,
      color: json['color'] != null ? _stringToColor(json['color'] as String) : null,
    );
  }
  
 
  static String _colorToString(Color color) {
    return '${color.a},${color.r},${color.g},${color.b}';
  }
  
  static Color _stringToColor(String colorStr) {
    List<int> components = colorStr.split(',').map((e) => int.parse(e)).toList();
    return Color.fromARGB(components[0], components[1], components[2], components[3]);
  }
}

final highlightProvider = StateNotifierProvider.family<HighlightNotifier, List<HighlightRange>, String>(
  (ref, chapterId) => HighlightNotifier(chapterId),
);

class HighlightNotifier extends StateNotifier<List<HighlightRange>> {
  final String chapterId;

  HighlightNotifier(this.chapterId) : super([]) {
    _loadHighlights();
  }

  Future<void> _loadHighlights() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final highlightsJson = prefs.getString('highlights_$chapterId');
      
      if (highlightsJson != null) {
        final highlightsList = jsonDecode(highlightsJson) as List;
        state = highlightsList
            .map((item) => HighlightRange.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading highlights: $e');
    }
  }

  Future<void> addHighlight(HighlightRange range) async {
    List<HighlightRange> newState = [...state];
    List<HighlightRange> overlappingRanges = [];
    
    for (var existing in state) {

      if ((range.start <= existing.end + 5 && range.end >= existing.start - 5)) {
        overlappingRanges.add(existing);
      }
    }
    
    if (overlappingRanges.isEmpty) {
      newState.add(range);
    } else {
      int mergedStart = range.start;
      int mergedEnd = range.end;
      
      for (var overlap in overlappingRanges) {
        mergedStart = mergedStart < overlap.start ? mergedStart : overlap.start;
        mergedEnd = mergedEnd > overlap.end ? mergedEnd : overlap.end;
        newState.remove(overlap);
      }
      
  
      Color? mergedColor = range.color;
      if (mergedColor == null && overlappingRanges.isNotEmpty) {
        mergedColor = overlappingRanges.first.color;
      }
      
      newState.add(HighlightRange(mergedStart, mergedEnd, color: mergedColor));
    }
    
    state = newState;
    await _saveHighlights();
  }

  Future<void> removeHighlight(HighlightRange range) async {
    state = state.where((r) => 
      !(r.start == range.start && r.end == range.end)
    ).toList();
    await _saveHighlights();
  }

  Future<void> _saveHighlights() async {
    try {
      debugPrint('Saving highlights for chapter: $chapterId');
      final prefs = await SharedPreferences.getInstance();
      final highlightsJson = jsonEncode(
        state.map((highlight) => highlight.toJson()).toList()
      );
      debugPrint('Highlights JSON: $highlightsJson');
      await prefs.setString('highlights_$chapterId', highlightsJson);
      debugPrint('Highlights saved successfully');
    } catch (e) {
      debugPrint('Error saving highlights: $e');
    }
  }
}
