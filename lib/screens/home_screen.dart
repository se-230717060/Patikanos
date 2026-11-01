import 'package:flutter/material.dart';

import 'today_screen.dart';
import 'explore_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedActivity = 'Bisiklet';

  final List<_NavItem> _navItems = const [
    _NavItem(label: 'Bugün', icon: Icons.sunny_snowing),
    _NavItem(label: 'Keşfet', icon: Icons.explore_outlined),
    _NavItem(label: 'Favoriler', icon: Icons.favorite_border),
    _NavItem(label: 'Profil', icon: Icons.person_outline),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onActivitySelected(String activity) {
    setState(() {
      _selectedActivity = activity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      TodayScreen(
        selectedActivity: _selectedActivity,
        onActivitySelected: _onActivitySelected,
      ),
      const ExploreScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF171A1D),
      body: SafeArea(
        top: true,
        bottom: false,
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFFE9E4DF),
        elevation: 0,
        height: 68,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTapped,
        destinations: _navItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.icon, color: const Color(0xFF1D7A68)),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
