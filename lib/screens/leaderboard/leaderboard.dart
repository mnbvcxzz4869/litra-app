import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/provider/leaderboard_provider.dart';
import 'package:litra/provider/user_data_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:litra/models/user.dart';

// Displays leaderboard sorted by level and experience points

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshLeaderboard();
  }

  Future<void> _refreshLeaderboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseDatabase.instance.ref().child('users').get();
      if (snapshot.exists && snapshot.value != null) {
        final usersData = snapshot.value as Map<dynamic, dynamic>;
        final users = <User>[];

        usersData.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            try {
              users.add(User(
                id: value['uid'] as String,
                name: value['name'] as String,
                profilePicture: value['profilePicture'] as String,
                level: value['level'] as int,
                exp: value['exp'] as int,
                coin: value['coin'] as int,
              ));
            } catch (e) {
              print('Error parsing user data: $e');
            }
          }
        });

        if (users.isNotEmpty) {
          for (final user in users) {
            ref.read(leaderboardProvider.notifier).updateUser(user);
          }
        }
      }
    } catch (e) {
      print('Error refreshing leaderboard: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final currentUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard 🏆'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshLeaderboard,
          ),
        ],
      ),
      body: _isLoading || leaderboardAsync.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: leaderboardAsync.length,
              itemBuilder: (context, index) {
                final user = leaderboardAsync[index];
                final isCurrentUser = user.id == currentUser.id;

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.tertiary.withAlpha(120),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        '#${index + 1}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isCurrentUser
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(width: 16),
                      CircleAvatar(
                          backgroundImage: AssetImage(user.profilePicture), radius: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: isCurrentUser
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Lvl ${user.level}',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isCurrentUser
                                            ? Theme.of(context).colorScheme.onPrimary
                                            : Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 86,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              user.coin.toString(),
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
