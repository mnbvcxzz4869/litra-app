// User data model
class User {
  final String id;
  final String name;
  final String profilePicture;
  final int level;
  final int exp;
  final int coin;

  User({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.level,
    required this.exp,
    required this.coin,
  });

  User copyWith({
    String? id,
    String? name,
    String? profilePicture,
    int? level,
    int? exp,
    int? coin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      coin: coin ?? this.coin,
    );
  }
}