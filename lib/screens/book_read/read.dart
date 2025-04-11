import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/models/book.dart';
import 'package:litra/provider/library_provider.dart';
import 'package:litra/provider/reading_theme_provider.dart';
import 'package:litra/provider/user_data_provider.dart';
import 'package:litra/screens/book_read/customise_view.dart';
import 'package:litra/screens/book_read/focus_mode_overlay.dart';
import 'package:litra/screens/book_read/navigation_widget.dart';
import 'package:litra/provider/highlight_provider.dart';
import 'highlight_text.dart';

// Main screen for reading book content 

class ReadScreen extends ConsumerStatefulWidget {
  const ReadScreen({super.key, required this.chapter, required this.book});

  final Chapter chapter;
  final Book book;

  @override
  ConsumerState<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends ConsumerState<ReadScreen> {
  late ScrollController _scrollController;
  final FocusNode _textFocusNode = FocusNode();
  final Color _currentHighlightColor = Colors.yellow.withAlpha(120);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      _onReadingFinished(context, ref);
    }
  }

  void _onReadingFinished(BuildContext context, WidgetRef ref) {
    if (widget.chapter.isReadRewardClaimed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exp and coins already claimed!'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      widget.chapter.isReadRewardClaimed = true;
    });

    final readChapters =
        widget.book.chapters.where((c) => c.isReadRewardClaimed).length;

    widget.book.chapterProgress = readChapters;

    ref.read(libraryProvider.notifier).addBook(widget.book);
    ref
        .read(libraryProvider.notifier)
        .updateProgress(widget.book.bookId, readChapters);

    ref.read(userProvider.notifier).update(25, 15);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exp and coins updated!'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final readingTheme = ref.watch(readingThemeProvider);
    final highlights = ref.watch(highlightProvider(widget.chapter.chapterId));
    final content = widget.chapter.chapterContent.join('\n\n');

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Chapter ${widget.chapter.chapterNum}',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              widget.chapter.chapterTitle,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => const CustomiseViewModal(),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: readingTheme.backgroundColor,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (BuildContext context) {
                            final GlobalKey textKey = GlobalKey();
                            
                            return GestureDetector(
                              onTapUp: (details) {
                                handleTextTapAccurate(
                                  details, 
                                  content, 
                                  highlights, 
                                  textKey,
                                  readingTheme,
                                  ref,
                                  widget.chapter.chapterId,
                                  _currentHighlightColor,
                                );
                              },
                              child: RichText(
                                key: textKey,
                                text: TextSpan(
                                  children: buildHighlightedText(
                                    content,
                                    highlights,
                                    readingTheme,
                                    _currentHighlightColor
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        NavigationWidget(
                          currentChapter: widget.chapter,
                          book: widget.book,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const FocusModeOverlay(),
        ],
      ),
    );
  }
}
