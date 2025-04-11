import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/models/book.dart';

/// Provider for accessing and managing the user's book library
final libraryProvider = StateNotifierProvider<LibraryNotifier, List<Book>>((ref) {
  return LibraryNotifier();
});

final lastAddedBookProvider = Provider<Book?>((ref) {
  final library = ref.watch(libraryProvider);
  return library.isNotEmpty ? library.first : null;
});

// Manages the state of the user's book library
class LibraryNotifier extends StateNotifier<List<Book>> {
  LibraryNotifier() : super([]);

  void addBook(Book book) {
    if (!state.any((existingBook) => existingBook.bookId == book.bookId)) {
      state = [book, ...state];
    }
  }

  void updateProgress(String bookId, int chapterProgress) {
    state = state.map((book) {
      if (book.bookId == bookId) {
        return Book(
          bookId: book.bookId,
          title: book.title,
          cover: book.cover,
          rating: book.rating,
          totalRead: book.totalRead,
          category: book.category,
          author: book.author,
          year: book.year,
          synopsis: book.synopsis,
          totalChapter: book.totalChapter,
          chapterProgress: chapterProgress,
          chapters: book.chapters,
        );
      }
      return book;
    }).toList();
  }
}