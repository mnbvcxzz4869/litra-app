// Home banner carousel
import 'package:flutter/material.dart';

class BannerCarousel extends StatefulWidget {
  final List<String> imagePaths;

  const BannerCarousel({super.key, required this.imagePaths});

  @override
  State<BannerCarousel> createState() {
    return _BannerCarouselState();
  }
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        if (_currentIndex == widget.imagePaths.length - 1) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          setState(() {
            _currentIndex = 0;
          });
        } else {
          setState(() {
            _currentIndex++;
          });
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        _startAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePaths.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                child: Image.asset(
                  widget.imagePaths[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imagePaths.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 4.0,
              width: _currentIndex == entry.key ? 24.0 : 8.0,
              decoration: BoxDecoration(
                color: _currentIndex == entry.key
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.tertiary.withAlpha(120),
                borderRadius: BorderRadius.circular(8.0),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
