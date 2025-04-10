// navigation bar
import 'package:flutter/material.dart';
import 'package:litra/screens/home/home.dart';
import 'package:litra/screens/leaderboard/leaderboard.dart';
import 'package:litra/screens/library/library.dart';
import 'package:litra/screens/profile.dart';
import 'package:litra/screens/search/search.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() {
    return _NavigationBarScreenState();
  }
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomeScreen();

    if (_selectedPageIndex == 0) {
      activePage = const HomeScreen();
    } else if (_selectedPageIndex == 1) {
      activePage = const SearchScreen();
    } else if (_selectedPageIndex == 2) {
      activePage = const LibraryScreen();
    } else if (_selectedPageIndex == 3) {
      activePage = const LeaderboardScreen();
    } else if (_selectedPageIndex == 4) {
      activePage = const ProfileScreen();
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
