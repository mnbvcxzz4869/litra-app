import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/models/user.dart';
import 'package:litra/provider/user_data_provider.dart';
import 'package:litra/data/leaderboard_data.dart';

class LeaderboardNotifier extends StateNotifier<List<User>> {
  LeaderboardNotifier(this.ref) : super(leaderboardData) {
    _sortLeaderboard();
    ref.listen<User>(userProvider, (previous, next) {
      updateUser(next);
    });
  }

  final Ref ref;

  void updateUser(User updatedUser) {
    state = state.map((user) {
      if (user.id == updatedUser.id) {
        return updatedUser.copyWith(
          exp: updatedUser.exp,
          coin: updatedUser.coin,
          level: updatedUser.level,
        );
      }
      return user;
    }).toList();
    _sortLeaderboard();
  }

  void _sortLeaderboard() {
    state.sort((a, b) {
      if (b.level == a.level) {
        return b.exp.compareTo(a.exp); 
      }
      return b.level.compareTo(a.level);
    });
  }
}

final leaderboardProvider = StateNotifierProvider<LeaderboardNotifier, List<User>>((ref) {
  return LeaderboardNotifier(ref);
});