import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:litra/models/user.dart';

// Provides Firebase Auth instance
final firebaseAuthProvider = Provider<auth.FirebaseAuth>((ref) {
  return auth.FirebaseAuth.instance;
});

// Listens to authentication state changes
final authStateProvider = StreamProvider<auth.User?>((ref) {
  return ref.read(firebaseAuthProvider).authStateChanges();
});

// Provides the current authenticated Firebase user
final authUserProvider = Provider<auth.User?>((ref) {
  return ref.watch(authStateProvider).value;
});

// Fetches detailed user data from Firebase Realtime Database for the currently 
// authenticated user and maps it to our app's User model
final firebaseUserProvider = FutureProvider<User?>((ref) async {
  final authUser = ref.watch(authUserProvider);
  if (authUser == null) return null;

  try {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(authUser.uid)
        .get();

    if (snapshot.exists && snapshot.value != null) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return User(
        id: data['uid'] as String,
        name: data['name'] as String,
        profilePicture: data['profilePicture'] as String,
        level: data['level'] as int,
        exp: data['exp'] as int,
        coin: data['coin'] as int,
      );
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
  return null;
});

// Streams a list of all users from the database
final allUsersProvider = StreamProvider<List<User>>((ref) {
  return FirebaseDatabase.instance.ref().child('users').onValue.map((event) {
    final dataSnapshot = event.snapshot;
    if (dataSnapshot.value == null) return [];

    final usersData = dataSnapshot.value as Map<dynamic, dynamic>;
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
    return users;
  });
});
