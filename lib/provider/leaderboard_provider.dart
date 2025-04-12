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
      } else if (next.value != null) {
        
        _forceRefresh();
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
          _sortLeaderboard(); // Make sure we sort after setting state
        }
      });
    });

    if (authState.value != null) {
      _forceRefresh();
    }
  }

  final Ref ref;
  
  // Force refresh data
  Future<void> _forceRefresh() async {
    try {
      final usersAsync = ref.read(allUsersProvider);
      usersAsync.whenData((users) {
        if (users.isNotEmpty) {
          state = [...users];
        }
      });
    } catch (e) {
      print('Error refreshing leaderboard: $e');
    }
  }

  // Updates user in the leaderboard
  void updateUser(User updatedUser) {
    if (updatedUser.id == '0') return;
    
    bool userExists = state.any((user) => user.id == updatedUser.id);
    
    if (userExists) {
      state = state.map((user) {
        if (user.id == updatedUser.id) {
          return updatedUser;
        }
        return user;
      }).toList();
    } else {
      state = [...state, updatedUser];
    }
    
    _sortLeaderboard(); // Ensure we sort after any changes
  }

  // Keep sorting logic in this central method
  void _sortLeaderboard() {
    final sortedList = List<User>.from(state);
    sortedList.sort((a, b) {
      if (b.level == a.level) {
        return b.exp.compareTo(a.exp); 
      }
      return b.level.compareTo(a.level);
    });
    
    state = sortedList;
  }
}

final leaderboardProvider = StateNotifierProvider<LeaderboardNotifier, List<User>>((ref) {
  return LeaderboardNotifier(ref);
});