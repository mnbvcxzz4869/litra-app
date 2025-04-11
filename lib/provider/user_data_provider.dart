import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/models/user.dart';
import 'package:litra/provider/firebase_user_provider.dart';
import 'package:litra/provider/leaderboard_provider.dart';

// Default user data
final defaultUser = User(
  id: '0',
  name: 'Guest',
  profilePicture: 'assets/user_profile_images/1.jpg',
  level: 0,
  exp: 0,
  coin: 0,
);

// Manages user data state and synchronizes with Firebase
class UserNotifier extends StateNotifier<User> {
  final Ref ref;
  UserNotifier(this.ref) : super(defaultUser) {
    // Reset to default user when logged out
    ref.listen(authStateProvider, (previous, next) {
      if (next.value == null) {
        state = defaultUser;
      }
    });
    
    ref.listen<AsyncValue<User?>>(firebaseUserProvider, (_, next) {
      next.whenData((user) {
        if (user != null) {
          state = user;
        }
      });
    });
  }

  void update(int addedExp, int addedCoin) {
    int newExp = state.exp + addedExp;
    int newLevel = state.level;

    if (newExp >= 3000) {
      newExp -= 3000;
      newLevel += 1;
    }

    state = state.copyWith(exp: newExp, coin: state.coin + addedCoin, level: newLevel);
    
    final authUser = ref.read(authUserProvider);
    if (authUser != null) {
      FirebaseDatabase.instance.ref().child('users').child(authUser.uid).update({
        'exp': newExp,
        'coin': state.coin,
        'level': newLevel,
      });
    }

    ref.read(leaderboardProvider.notifier).updateUser(state);
  }

  void useCoin(int usedCoin) {
    state = state.copyWith(coin: state.coin - usedCoin);

    final authUser = ref.read(authUserProvider);
    if (authUser != null) {
      FirebaseDatabase.instance.ref().child('users').child(authUser.uid).update({
        'coin': state.coin,
      });
    }

    ref.read(leaderboardProvider.notifier).updateUser(state);
  }
  
  Future<void> logout() async {
    await auth.FirebaseAuth.instance.signOut();
    state = defaultUser;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier(ref);
});