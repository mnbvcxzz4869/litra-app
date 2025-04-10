import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/provider/reading_theme_provider.dart';
import 'package:litra/screens/book_read/color_theme.dart';

class CustomiseViewModal extends ConsumerWidget {
  const CustomiseViewModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingTheme = ref.watch(readingThemeProvider);
    final readingThemeNotifier = ref.read(readingThemeProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Typography', style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: readingTheme.fontFamily,
                  items: const [
                    DropdownMenuItem(
                      value: 'Literata',
                      child: Text('Literata'),
                    ),
                    DropdownMenuItem(value: 'Roboto', child: Text('Roboto')),
                    DropdownMenuItem(
                      value: 'Montserrat',
                      child: Text('Montserrat'),
                    ),
                    DropdownMenuItem(
                      value: 'Open Sans',
                      child: Text('Open Sans'),
                    ),
                    DropdownMenuItem(value: 'Inter', child: Text('Inter')),
                    DropdownMenuItem(value: 'Lato', child: Text('Lato')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      readingThemeNotifier.updateField(fontFamily: value);
                    }
                  },
                ),
                DropdownButton<String>(
                  value: readingTheme.fontWeight,
                  items: const [
                    DropdownMenuItem(value: 'Regular', child: Text('Regular')),
                    DropdownMenuItem(value: 'Bold', child: Text('Bold')),
                  ],
                  onChanged: (value) {
                    readingThemeNotifier.updateField(fontWeight: value);
                  },
                ),
                DropdownButton<double>(
                  value: readingTheme.fontSize,
                  items: const [
                    DropdownMenuItem(value: 14, child: Text('14')),
                    DropdownMenuItem(value: 16, child: Text('16')),
                    DropdownMenuItem(value: 18, child: Text('18')),
                    DropdownMenuItem(value: 22, child: Text('22')),
                    DropdownMenuItem(value: 24, child: Text('24')),
                  ],
                  onChanged: (value) {
                    readingThemeNotifier.updateField(fontSize: value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text('Theme', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColorTheme(readingThemeNotifier:readingThemeNotifier, backgroundColor: Color(0xFFFBF8F2), fontColor: Color(0xFF1D1E19)),
                ColorTheme(readingThemeNotifier:readingThemeNotifier,backgroundColor: Color(0xFFFFFFFF), fontColor: Color(0xFF383838)),
                ColorTheme(readingThemeNotifier:readingThemeNotifier,backgroundColor: Color(0xFFE5E5E5), fontColor: Color(0xFF000000)),
                ColorTheme(readingThemeNotifier:readingThemeNotifier,backgroundColor: Color(0xFFF3E9D9), fontColor: Color(0xFF2B2A30)),
                ColorTheme(readingThemeNotifier:readingThemeNotifier,backgroundColor: Color(0xFF313338), fontColor: Color(0xFFF2F3F4)),
                ColorTheme(readingThemeNotifier:readingThemeNotifier,backgroundColor: Color(0xFF2B2A30), fontColor: Color(0xFFF8F8F8)),
                ColorTheme(readingThemeNotifier:readingThemeNotifier,backgroundColor: Color(0xFF1A1A1A), fontColor: Color(0xFFFFFFFF)),
              ],
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
