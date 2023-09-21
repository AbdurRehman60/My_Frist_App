import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id;
  final String? eamil;
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.eamil,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        eamil: user.email,
        isEmailVerified: user.emailVerified,
      );

  reload() {}
}
