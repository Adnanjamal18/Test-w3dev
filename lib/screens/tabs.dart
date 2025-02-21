import 'package:flutter/material.dart';
import 'package:interntest/screens/Profile.dart';
import 'package:interntest/screens/homescreen.dart';
import 'package:interntest/screens/settings.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
  HomeScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 46, 46, 46),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.tealAccent,     
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home.png',
              color: _currentIndex == 0
                  ? Colors.tealAccent
                  : Colors.grey,
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
        radius: 18, // Adjust size
       // backgroundColor: Colors.transparent, 
        backgroundImage: AssetImage('assets/person.png'), // No color overlay
      ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.settings),
      label: "Settings",
          ),
        ],
      ),
    );
  }
}