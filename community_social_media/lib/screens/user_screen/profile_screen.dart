import 'package:community_social_media/services/auth_service.dart';
import 'package:community_social_media/services/firestore_service.dart';
import 'package:flutter/material.dart';

AuthService _authService = AuthService();

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        _authService.signOut(context);
      }),
    );
  }
}
