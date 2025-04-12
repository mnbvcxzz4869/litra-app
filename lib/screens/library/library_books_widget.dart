import 'package:flutter/material.dart';
import 'package:litra/screens/book_details/book_details.dart';
import 'package:litra/screens/book_listen/listen.dart';
import 'package:litra/screens/book_read/read.dart';
import 'package:litra/screens/library/ai_recap.dart';

// Displays a book from the user's library with reading progress

class LibraryBooksWidget extends StatelessWidget {
  final dynamic book;
  final double progress;

  const LibraryBooksWidget({
    super.key,
    required this.book,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.tertiary.withAlpha(120),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(book.cover, width: 90, height: 144, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  'Chapter ${book.chapterProgress} of ${book.totalChapter}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: book.chapterProgress / book.totalChapter,
                          backgroundColor: Theme.of(context).colorScheme.tertiary.withAlpha(120),
                          color: Theme.of(context).colorScheme.primary,
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${progress.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildActionButton(context, book)),
                    if (book.chapterProgress < book.totalChapter)
                      const SizedBox(width: 8), 
                    if (book.chapterProgress < book.totalChapter)
                      Expanded(child: _buildRewards(context)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, dynamic book) {
    final isCompleted = book.chapterProgress == book.totalChapter;
    return InkWell(
      onTap: () {
        if (isCompleted) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetails(book: book)));
        } else {
          final nextChapter = book.chapters[book.chapterProgress];
          final screen = nextChapter.isListenRewardClaimed
              ? ListenScreen(book: book, chapter: nextChapter)
              : ReadScreen(book: book, chapter: nextChapter);
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        }
      },
      child: Container(
        height: 40, // Fixed height
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            isCompleted ? 'Completed' : 'Continue',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewards(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AiRecap(book: book, chapterProgress: book.chapterProgress),
          ),
        );
      },
      child: Container(
        height: 40, // Fixed height
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            'AI Recap',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
