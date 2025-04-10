// Books filter based on selected category
import 'package:flutter/material.dart';
import 'package:litra/data/books_data.dart';
import 'package:litra/models/category.dart';
import 'package:litra/screens/search/book_card_large.dart';

class CategoryBooksFilter extends StatefulWidget {
  const CategoryBooksFilter({super.key});

  @override
  State<CategoryBooksFilter> createState() {
    return _CategoryBooksListState();
  }
}

class _CategoryBooksListState extends State<CategoryBooksFilter> {
  String selectedCategory = 'Horror';

  @override
  Widget build(BuildContext context) {
    final filteredBooks =
        dummyBooks.where((book) {
          final category = categories.firstWhere(
            (cat) => cat.title == selectedCategory,
            orElse: () => const Category(id: '', title: ''),
          );
          return book.category.contains(category.id);
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                categories.map((category) {
                  final isSelected = category.title == selectedCategory;
                  final isLast = category == categories.last;
                  return Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : 8),
                    child: ChoiceChip(
                      label: Text(category.title),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category.title;
                        });
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      labelStyle: TextStyle(
                        color:
                            isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Books Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(top: 0, bottom: 16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.52,
            ),
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              return BookCardLarge(book: filteredBooks[index]);
            },
          ),
        ),
      ],
    );
  }
}
