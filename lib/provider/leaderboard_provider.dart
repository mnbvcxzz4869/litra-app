import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/models/user.dart';
import 'package:litra/provider/firebase_user_provider.dart';
import 'package:litra/provider/user_data_provider.dart';
import 'package:litra/data/leaderboard_data.dart';

// Manages the leaderboard state and synchronizes it with user data
class LeaderboardNotifier extends StateNotifier<List<User>> {
  LeaderboardNotifier(this.ref) : super([]) {
    final authState = ref.read(authStateProvider);
    state = authState.value != null ? [] : leaderboardData;
    
    ref.listen(authStateProvider, (previous, next) {
      if (next.value == null) {
        state = leaderboardData;
      } else if (next.value != null && previous?.value == null) {
        state = [];
      }
    });
  
    ref.listen<User>(userProvider, (previous, next) {
      if (next.id != '0') {
        updateUser(next);
      }
    });
    
    ref.listen<AsyncValue<List<User>>>(allUsersProvider, (_, next) {
      next.whenData((users) {
        if (users.isNotEmpty) {
          state = [...users];
          _sortLeaderboard();
        }
      });
    });
  }

  final Ref ref;

  // Updates user in the leaderboard and re-sorts
  void updateUser(User updatedUser) {
    if (updatedUser.id == '0') return; 
    
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

  // Sorts the leaderboard by level and exp
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