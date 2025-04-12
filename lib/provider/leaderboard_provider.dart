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
        // User just logged in - fetch data immediately
        _fetchUserData(next.value!.uid);
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

    if (authState.value != null) {
      _initializeLeaderboard();
    }
  }

  final Ref ref;

  // Fetches specific user data by ID
  Future<void> _fetchUserData(String userId) async {
    try {
      final allUsers = await ref.read(allUsersProvider.future);
      if (allUsers.isNotEmpty) {
        state = [...allUsers];
        _sortLeaderboard();
        return;
      }
    } catch (e) {
      // 
    }

    _initializeLeaderboard();
  }

  // Fetches all users and updates the leaderboard
  Future<void> _initializeLeaderboard() async {
    try {
      final users = await ref.read(allUsersProvider.future);
      if (users.isNotEmpty) {
        state = [...users];
        _sortLeaderboard();
      }
    } catch (e) {
      // 
    }
  }

  // Updates user in the leaderboard and re-sorts
  void updateUser(User updatedUser) {
    if (updatedUser.id == '0') return;
    
    bool userExists = state.any((user) => user.id == updatedUser.id);
    
    if (userExists) {
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
    } else {
      state = [...state, updatedUser];
    }
    _sortLeaderboard();
  }

  // Sorts the leaderboard by level and exp
  void _sortLeaderboard() {
    final sortedList = List<User>.from(state);
    sortedList.sort((a, b) {
      if (b.level == a.level) {
        return b.exp.compareTo(a.exp); 
      }
      return b.level.compareTo(a.level);
    });
    
    if (sortedList.isNotEmpty) {
      state = sortedList;
    }
  }
}

final leaderboardProvider = StateNotifierProvider<LeaderboardNotifier, List<User>>((ref) {
  return LeaderboardNotifier(ref);
});