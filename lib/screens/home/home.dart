// home page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/data/books_data.dart';
import 'package:litra/data/user_data.dart';
import 'package:litra/provider/library_provider.dart';
import 'package:litra/screens/home/banner_carousel.dart';
import 'package:litra/screens/home/book_card_slider.dart';
import 'package:litra/screens/library/library_books_widget.dart';
import 'package:litra/screens/home/user_home.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastAddedBook = ref.watch(lastAddedBookProvider); // Use the reactive provider

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header text
                Text(
                  'Hey, ${userData[0].name} 👋',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 16),
                // User profile
                UserHome(),
                const SizedBox(height: 16),
                // Last Added Book Section
                if (lastAddedBook != null) ...[
                  LibraryBooksWidget(
                    book: lastAddedBook,
                    progress: (lastAddedBook.chapterProgress / lastAddedBook.totalChapter) * 100,
                  ),
                  const SizedBox(height: 16),
                ],
                // Banner carousel
                BannerCarousel(
                  imagePaths: [
                    'assets/banners/banner-1.webp',
                    'assets/banners/banner-2.webp',
                    'assets/banners/banner-3.webp',
                  ],
                ),
                const SizedBox(height: 16),
                // Book card sliders
                BookCardSlider(header: 'Recommend', bookList: dummyBooks),
                const SizedBox(height: 16),
                BookCardSlider(header: 'Popular', bookList: dummyBooks),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
