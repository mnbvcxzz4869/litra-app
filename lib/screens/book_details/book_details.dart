import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:litra/models/book.dart';
import 'package:litra/models/category.dart';
import 'package:litra/screens/book_details/book_chapter_list.dart';
class BookDetails extends StatelessWidget {
  const BookDetails({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 16),
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
                  child: Image.asset(book.cover, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Wrap(
                spacing: 8.0,
                children:
                    book.category.map((categoryId) {
                      final category = categories.firstWhere(
                        (cat) => cat.id == categoryId,
                      );
                      return Chip(
                        label: Text(
                          category.title,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      );
                    }).toList(),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${book.author} | ${book.year}'),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+${book.totalChapter * 30} XP',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+${book.totalChapter * 15}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.tertiary.withAlpha(120),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('⭐ ${book.rating}/5'),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.tertiary.withAlpha(120),
                      thickness: 1,
                    ),
                    Text('${book.totalRead} Reads'),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.tertiary.withAlpha(120),
                      thickness: 1,
                    ),
                    Text('${book.totalChapter} Chapters'),
                  ],
                ),
              ),
            ),
           
          DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                      indicatorColor: Theme.of(context).colorScheme.primary,
                      tabs: const [
                        Tab(text: 'Synopsis'),
                        Tab(text: 'Chapter'),
                        Tab(text: 'Review'),
                      ],
                    ),
                    AutoScaleTabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              book.synopsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          BookChaptersList(book: book, chapters: book.chapters),
                          Center(
                            child: Text(
                              'Under Development',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
