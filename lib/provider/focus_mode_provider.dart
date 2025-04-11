import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// Provider to manage the focus mode state throughout the app
final focusModeProvider = StateNotifierProvider<FocusModeNotifier, FocusModeState>(
  (ref) => FocusModeNotifier(),
);

// Represents the state of the focus mode feature
// - isActive: Whether focus mode is currently running
// - remainingTime: Seconds left in the current focus session
// - position: Position of the focus mode timer overlay on screen
class FocusModeState {
  final bool isActive;
  final int remainingTime; 
  final Offset position; 

  FocusModeState({
    required this.isActive,
    required this.remainingTime,
    required this.position,
  });

  FocusModeState copyWith({
    bool? isActive,
    int? remainingTime,
    Offset? position,
  }) {
    return FocusModeState(
      isActive: isActive ?? this.isActive,
      remainingTime: remainingTime ?? this.remainingTime,
      position: position ?? this.position,
    );
  }
}

// Manages the focus mode state and timer functionality
class FocusModeNotifier extends StateNotifier<FocusModeState> {
  FocusModeNotifier()
      : super(FocusModeState(
          isActive: false,
          remainingTime: 0,
          position: const Offset(20, 100),
        ));

  void startFocusMode(int durationInSeconds) {
    state = state.copyWith(isActive: true, remainingTime: durationInSeconds);
    _startTimer();
  }

  void stopFocusMode() {
    state = state.copyWith(isActive: false, remainingTime: 0);
  }

  void updatePosition(Offset newPosition) {
    state = state.copyWith(position: newPosition);
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (state.isActive && state.remainingTime > 0) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
        _startTimer();
      } else if (state.remainingTime == 0) {
        stopFocusMode();
      }
    });
  }
}
