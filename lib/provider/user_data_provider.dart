import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/data/user_data.dart';
import 'package:litra/models/user.dart';
import 'package:litra/provider/leaderboard_provider.dart';

class UserNotifier extends StateNotifier<User> {
  final Ref ref;
  UserNotifier(this.ref) : super(userData[0]);

  void update(int addedExp, int addedCoin) {
    int newExp = state.exp + addedExp;
    int newLevel = state.level;

    if (newExp >= 3000) {
      newExp -= 3000;
      newLevel += 1;
    }

    state = state.copyWith(exp: newExp, coin: state.coin + addedCoin, level: newLevel);

    ref.read(leaderboardProvider.notifier).updateUser(state);
  }

  void useCoin(int usedCoin) {
    state = state.copyWith(coin: state.coin - usedCoin);

    ref.read(leaderboardProvider.notifier).updateUser(state);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier(ref);
});