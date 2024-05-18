import 'package:community_social_media/screens/auth_screen/auth_screen.dart';
import 'package:community_social_media/screens/events_screen/events_screen.dart';
import 'package:community_social_media/screens/user_screen/profile_screen.dart';
import 'package:flutter/material.dart';

import 'screens/explore_screen/explore_screen.dart';

class BottomNavBarBuilder extends StatefulWidget {
  const BottomNavBarBuilder({super.key});

  @override
  State<BottomNavBarBuilder> createState() => _BottomNavBarBuilderState();
}

class _BottomNavBarBuilderState extends State<BottomNavBarBuilder> {
  int currentIndex = 0;
  final List<Widget> screens = <Widget>[
    const ExploreScreen(),
    const EventsScreen(),
    const AuthScreen()
  ];

  final List<Widget> items = [
    const NavigationDestination(
        icon: Icon(
          Icons.explore_rounded,
        ),
        label: ""),
    const NavigationDestination(icon: Icon(Icons.event), label: ""),
    const NavigationDestination(icon: Icon(Icons.person), label: ""),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        body: screens[currentIndex],
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: items,
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ));
  }
}
