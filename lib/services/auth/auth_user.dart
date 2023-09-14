import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String? eamil;
  final bool isEmailVerified;
  const AuthUser({
    required this.eamil,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        eamil: user.email,
        isEmailVerified: user.emailVerified,
      );

  reload() {}
}
