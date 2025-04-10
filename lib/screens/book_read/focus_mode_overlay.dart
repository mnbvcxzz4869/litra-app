import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/provider/focus_mode_provider.dart';

class FocusModeOverlay extends ConsumerStatefulWidget {
  const FocusModeOverlay({super.key});

  @override
  ConsumerState<FocusModeOverlay> createState() => _FocusModeOverlayState();
}

class _FocusModeOverlayState extends ConsumerState<FocusModeOverlay> {
  @override
  Widget build(BuildContext context) {
    final focusModeState = ref.watch(focusModeProvider);
    final focusModeNotifier = ref.read(focusModeProvider.notifier);

    return Positioned(
      left: focusModeState.position.dx,
      top: focusModeState.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          final screenSize = MediaQuery.of(context).size;

          final newPosition = Offset(
            (focusModeState.position.dx + details.delta.dx).clamp(0, screenSize.width - 150),
            (focusModeState.position.dy + details.delta.dy).clamp(0, screenSize.height - 100),
          );
          
          focusModeNotifier.updatePosition(newPosition);
        },
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(120),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (focusModeState.isActive)
                  Text(
                    _formatTime(focusModeState.remainingTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                else
                  Text(
                    'Focus',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(width: 8),
                Switch(
                  value: focusModeState.isActive,
                  onChanged: (value) {
                    if (value) {
                      focusModeNotifier.startFocusMode(25 * 60);
                    } else {
                      focusModeNotifier.stopFocusMode();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
