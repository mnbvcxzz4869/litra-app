import 'package:flutter/material.dart';
import 'package:litra/models/book.dart';
import 'package:litra/screens/book_read/read.dart';

// Handles navigation between book chapters

class NavigationWidget extends StatelessWidget {
  final Chapter currentChapter;
  final Book book;

  const NavigationWidget({
    super.key,
    required this.currentChapter,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: currentChapter.chapterNum > 1
                ? () => _navigateToChapter(context, currentChapter.chapterNum - 1)
                : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade600,
            ),
          ),

          ElevatedButton.icon(
            onPressed: currentChapter.chapterNum < book.chapters.length
                ? () => _navigateToChapter(context, currentChapter.chapterNum + 1)
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

 
  // Finds the target chapter by its number and navigates to it
  void _navigateToChapter(BuildContext context, int chapterNum) {
    final targetChapter = book.chapters.firstWhere(
      (chapter) => chapter.chapterNum == chapterNum,
      orElse: () => currentChapter,
    );

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ReadScreen(
          chapter: targetChapter,
          book: book,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
