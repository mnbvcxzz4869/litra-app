import 'package:litra/models/user.dart';

final leaderboardData = [
  User(
    id: '1',
    name: 'John Doe',
    profilePicture: 'assets/user_profile_images/1.jpg',
    level: 2,
    exp: 2800,
    coin: 2900,
  ),
  User(
    id: '2',
    name: 'Jane Smith',
    profilePicture: 'assets/user_profile_images/1.jpg',
    level: 3,
    exp: 5,
    coin: 3200,
  ),
  User(
    id: '3',
    name: 'Alice Son',
    profilePicture: 'assets/user_profile_images/1.jpg',
    level: 1,
    exp: 1500,
    coin: 1200,
  ),
];

List<User> getLeaderboardByExp() {
  leaderboardData.sort((a, b) => b.exp.compareTo(a.exp));
  return leaderboardData;
}

List<User> getLeaderboardForUser(String userId) {
  return leaderboardData.where((user) => user.id == userId).toList();
}