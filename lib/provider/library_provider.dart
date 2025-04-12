import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/models/book.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const String _libraryKey = 'library_books';
  
  LibraryNotifier() : super([]) {
    _loadLibrary();
  }

  // Load library data from shared preferences
  Future<void> _loadLibrary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final libraryJson = prefs.getStringList(_libraryKey);
      
      if (libraryJson != null) {
        final books = libraryJson
            .map((bookJson) => Book.fromJson(jsonDecode(bookJson)))
            .toList();
        state = books;
      }
    } catch (e) {
      // Handle error loading data (optional logging)
      print('Error loading library: $e');
    }
  }

  // Save library data to shared preferences
  Future<void> _saveLibrary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final libraryJson = state.map((book) => jsonEncode(book.toJson())).toList();
      await prefs.setStringList(_libraryKey, libraryJson);
    } catch (e) {
      // Handle error saving data (optional logging)
      print('Error saving library: $e');
    }
  }

  void addBook(Book book) {
    if (!state.any((existingBook) => existingBook.bookId == book.bookId)) {
      state = [book, ...state];
      _saveLibrary();
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
    _saveLibrary();
  }
}