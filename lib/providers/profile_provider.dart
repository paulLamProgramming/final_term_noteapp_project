import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:final_noteapp_new/constants/db_contants.dart';
import 'package:final_noteapp_new/models/user_model.dart';
import 'package:flutter/foundation.dart';

class ProfileState extends Equatable {
  final bool loading;
  final User user;

  ProfileState({required this.loading, required this.user});

  ProfileState copyWith({
    required bool loading,
    required User user,
  }) {
    return ProfileState(
      loading: loading,
      user: user,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [loading, user];
}

class ProfileProvider with ChangeNotifier {
  ProfileState state = ProfileState(loading: false, user: users, );

  get user => null;

  static get users => null;

  Future<void> getUserProfile(String userId) async {
    state = state.copyWith(loading: true, user: user);
    notifyListeners();

    try {
      DocumentSnapshot userDoc = await usersRef.doc(userId).get();

      if (userDoc.exists) {
        User user = User.fromDoc(userDoc);
        state = state.copyWith(loading: false, user: user);
        notifyListeners();
      } else {
        throw Exception('Fail to get user info');
      }
    } catch (e) {
      state = state.copyWith(loading: false, user: user);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> editUserProfile(
      String userId,
      String name,
      String email,
      ) async {
    state = state.copyWith(loading: true, user: user);
    notifyListeners();

    try {
      await usersRef.doc(userId).update({
        'name': name,
      });
      state = state.copyWith(
        loading: false,
        user: User(id: userId, name: name, email: email),
      );
      notifyListeners();
    } catch (e) {
      state = state.copyWith(loading: false, user: user);
      notifyListeners();
      rethrow;
    }
  }
}