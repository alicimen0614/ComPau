import 'package:community_social_media/bottom_nav_bar_builder.dart';
import 'package:community_social_media/firebase_options.dart';
import 'package:community_social_media/screens/auth/auth_screen.dart';
import 'package:community_social_media/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

AuthService _authService = AuthService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        navigationBarTheme:
            const NavigationBarThemeData(backgroundColor: Color(0xFF004485)),
        scaffoldBackgroundColor: const Color(0xFFEEF5FF),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF007dc4),
            secondary: const Color(0xFF004485)),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: _authService.authState,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return const BottomNavBarBuilder();
            }
            return const AuthScreen();
          }),
    );
  }
}
