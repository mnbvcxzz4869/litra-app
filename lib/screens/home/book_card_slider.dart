import 'package:flutter/material.dart';
import 'package:litra/models/book.dart';
import 'package:litra/screens/home/book_card_small.dart';

// For displaying categorized book collections on the home screen

class BookCardSlider extends StatelessWidget {
  const BookCardSlider({
    super.key,
    required this.header,
    required this.bookList,
  });

  final String header;
  final List<Book> bookList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < bookList.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    right: i == bookList.length - 1 ? 0 : 10,
                  ),
                  child: 
                  BookCardSmall(book: bookList[i]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
