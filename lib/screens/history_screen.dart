import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      // navbar
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}
