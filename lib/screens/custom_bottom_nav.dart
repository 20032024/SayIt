import 'package:flutter/material.dart';
import 'package:project_sayit/screens/home_screen.dart';
import 'package:project_sayit/screens/settings_screen.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Categorías'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
      ],
      onTap: (index) {
        if (index == currentIndex) return; // evita recargar la misma pantalla

        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CategoriesScreen()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        }
      },
    );
  }
}
