import 'package:community_social_media/bottom_nav_bar_builder.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF007dc4),
            secondary: const Color(0xFF004485)),
        useMaterial3: true,
      ),
      home: const BottomNavBarBuilder(),
    );
  }
}
