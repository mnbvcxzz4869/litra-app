import 'package:flutter/material.dart';
import 'package:litra/data/books_data.dart';
import 'package:litra/models/book.dart';
import 'package:litra/screens/search/book_card_large.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _filteredBooks = [];
  final List<Book> _allBooks = dummyBooks;

  @override
  void initState() {
    super.initState();
    _filteredBooks = List.from(_allBooks); 
  }

  void _filterBooks(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBooks = List.from(_allBooks);
      } else {
        _filteredBooks = _allBooks
            .where(
              (book) =>
                  book.title.toLowerCase().contains(query.toLowerCase()) ||
                  book.author.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _filterBooks,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search books...',
            border: InputBorder.none,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body:
          _filteredBooks.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Image.asset(
                      'assets/illustration/search-notfound.png',
                      width: 500,
                      height: 500,
                    ),
                    Text(
                      'Ups!... no results found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please try another search',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
              : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.52,
                ),
                itemCount: _filteredBooks.length,
                itemBuilder: (context, index) {
                  return BookCardLarge(book: _filteredBooks[index]);
                },
              ),
    );
  }
}
