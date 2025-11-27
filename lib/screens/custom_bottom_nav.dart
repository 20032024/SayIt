import 'package:flutter/material.dart';
import 'package:project_sayit/screens/home_screen.dart';
import 'package:project_sayit/screens/settings_screen.dart';
import 'package:project_sayit/screens/history_screen.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.lock_clock), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
      ],
      onTap: (index) {
        if (index == currentIndex) return; // evita recargar la misma pantalla

        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HistoryScreen()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        }
      },
    );
  }
}
