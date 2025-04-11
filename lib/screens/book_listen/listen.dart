import 'package:flutter/material.dart';
import 'package:litra/models/book.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:litra/provider/library_provider.dart';
import 'package:litra/screens/book_listen/audio_player_widget.dart';
import 'package:litra/screens/book_listen/listen_chapter_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/provider/user_data_provider.dart';

// Audio player screen for books that allows users to listen to chapters
class ListenScreen extends ConsumerStatefulWidget {
  final Book book;
  final Chapter chapter;

  const ListenScreen({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  ConsumerState<ListenScreen> createState() {
    return _ListenScreenState();
  }
}

class _ListenScreenState extends ConsumerState<ListenScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
    _autoPlayAudio();
  }

  void _onListeningFinished() {
  if (widget.chapter.isListenRewardClaimed) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exp and coins already claimed!'),
        duration: Duration(seconds: 3),
      ),
    );
    return;
  }

  setState(() {
    widget.chapter.isListenRewardClaimed = true;
  });

  final book = widget.book;
  final listenedChapters = book.chapters.where((c) => c.isListenRewardClaimed).length;

  ref.read(libraryProvider.notifier).addBook(book);
  ref.read(libraryProvider.notifier).updateProgress(book.bookId, listenedChapters);

  
  ref.read(userProvider.notifier).update(25, 15);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Exp and coins updated!'),
      duration: Duration(seconds: 3),
    ),
  );
}

  void _setupAudioPlayer() {
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        totalDuration = duration;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        currentPosition = Duration.zero;
        isPlaying = false;
      });
      _onListeningFinished(); 
    });
  }

  void _autoPlayAudio() async {
    await _audioPlayer.play(AssetSource(widget.chapter.audioFile));
  }

  void _playPauseAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(widget.chapter.audioFile));
    }
  }

  Future<void> _playChapter(Chapter chapter) async {
    if (chapter.chapterId == widget.chapter.chapterId) {
      return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ListenScreen(
          book: widget.book,
          chapter: chapter,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book.title,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 255,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.tertiary.withAlpha(120),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                child: Image.asset(widget.book.cover, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 16),

            // Display current chapter information
            Text(
              'Chapter ${widget.chapter.chapterNum}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              widget.chapter.chapterTitle,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            AudioPlayerWidget(
              audioPlayer: _audioPlayer,
              isPlaying: isPlaying,
              currentPosition: currentPosition,
              totalDuration: totalDuration,
              onPlayPause: _playPauseAudio,
              onSeek: (position) async {
                await _audioPlayer.seek(position);
              },
            ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Chapter List',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListenChapterList(
                book: widget.book,
                currentChapterId: widget.chapter.chapterId,
                onChapterSelected: _playChapter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}