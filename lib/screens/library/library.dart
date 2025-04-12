import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/provider/library_provider.dart';
import 'package:litra/screens/library/library_books_widget.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(libraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library 📚'),
        automaticallyImplyLeading: false,
      ),
      body: library.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/illustration/start-reading.png',
                    width: 500,
                    height: 500,
                  ),
                  Text(
                    'Your library is empty',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start reading',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: ListView.builder(
                itemCount: library.length,
                itemBuilder: (context, index) {
                  final book = library[index];
                  final progress = (book.chapterProgress / book.totalChapter) * 100;

                  return LibraryBooksWidget(
                    book: book,
                    progress: progress,
                  );
                },
              ),
            ),
    );
  }
}