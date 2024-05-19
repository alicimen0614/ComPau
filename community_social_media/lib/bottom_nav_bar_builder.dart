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
    const ProfileScreen()
  ];

  final List<Widget> items = [
    const NavigationDestination(
        selectedIcon: Icon(
          Icons.explore_rounded,
          color: Color(0xFF004485),
          size: 30,
        ),
        icon: Icon(
          Icons.explore_rounded,
          color: Colors.white,
          size: 30,
        ),
        label: ""),
    const NavigationDestination(
        selectedIcon: Icon(
          Icons.event,
          color: Color(0xFF004485),
          size: 30,
        ),
        icon: Icon(
          Icons.event,
          color: Colors.white,
          size: 30,
        ),
        label: ""),
    const NavigationDestination(
        selectedIcon: Icon(
          Icons.person,
          color: Color(0xFF004485),
          size: 30,
        ),
        icon: Icon(
          Icons.person,
          color: Colors.white,
          size: 30,
        ),
        label: ""),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        body: screens[currentIndex],
        bottomNavigationBar: NavigationBar(
          shadowColor: Colors.black,
          surfaceTintColor: Colors.black,
          indicatorColor: Colors.white,
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
