import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;

  const AudioPlayerWidget({
    super.key,
    required this.audioPlayer,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.onPlayPause,
    required this.onSeek,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
  value: widget.currentPosition.inSeconds.toDouble() < widget.totalDuration.inSeconds.toDouble()
      ? widget.currentPosition.inSeconds.toDouble()
      : widget.totalDuration.inSeconds.toDouble(),
  min: 0.0,
  max: widget.totalDuration.inSeconds > 0
      ? widget.totalDuration.inSeconds.toDouble()
      : 1.0,
  onChanged: (value) {
    widget.onSeek(Duration(seconds: value.toInt()));
  },
),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDuration(widget.currentPosition)),
            Text(_formatDuration(widget.totalDuration)),
          ],
        ),
        SizedBox(height: 4,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: const Icon(Icons.skip_previous),
              onPressed: () async {
                final newPosition = widget.currentPosition - const Duration(seconds: 30);
                await widget.audioPlayer.seek(newPosition > Duration.zero ? newPosition : Duration.zero);
              },),
            IconButton(
              icon: const Icon(Icons.replay_10),
              onPressed: () async {
                final newPosition = widget.currentPosition - const Duration(seconds: 10);
                await widget.audioPlayer.seek(newPosition > Duration.zero ? newPosition : Duration.zero);
              },
            ),
            ElevatedButton(
              onPressed: widget.onPlayPause,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
              child: Icon(widget.isPlaying ? Icons.pause : Icons.play_arrow, size: 28),
            ),
            IconButton(
              icon: const Icon(Icons.forward_10),
              onPressed: () async {
                final newPosition = widget.currentPosition + const Duration(seconds: 10);
                await widget.audioPlayer.seek(newPosition < widget.totalDuration ? newPosition : widget.totalDuration);
              },
            ),
            IconButton(icon: const Icon(Icons.skip_next),
              onPressed: () async {
                final newPosition = widget.currentPosition + const Duration(seconds: 30);
                await widget.audioPlayer.seek(newPosition < widget.totalDuration ? newPosition : widget.totalDuration);
              },),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}