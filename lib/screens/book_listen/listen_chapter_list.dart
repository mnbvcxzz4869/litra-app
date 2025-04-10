import 'package:flutter/material.dart';
import 'package:litra/models/book.dart';

class ListenChapterList extends StatelessWidget {
  final Book book;
  final String currentChapterId;
  final Function(Chapter) onChapterSelected;

  const ListenChapterList({
    super.key,
    required this.book,
    required this.currentChapterId,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: book.chapters.length,
      itemBuilder: (context, index) {
        final chapterItem = book.chapters[index];
        final isCurrentChapter = chapterItem.chapterId == currentChapterId;

        return ElevatedButton(
          onPressed: () => onChapterSelected(chapterItem),
          style: ElevatedButton.styleFrom(
            backgroundColor: isCurrentChapter
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Row(
            children: [
              Text(
                chapterItem.chapterNum.toString(),
                style: TextStyle(
                  color: isCurrentChapter
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 16,),
              Text(
                chapterItem.chapterTitle,
                style: TextStyle(
                  color: isCurrentChapter
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}