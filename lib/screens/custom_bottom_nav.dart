import 'package:flutter/material.dart';
import 'package:project_sayit/screens/home_screen.dart';
import 'package:project_sayit/screens/settings_screen.dart';
import 'package:project_sayit/screens/history_screen.dart';

// ⚠️ Colores coherentes con el resto de la app
const Color kPrimaryOrange = Color(0xFFF08C69);
const Color kMinimalBackground = Color(0xFFF5F5F5);

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  // Definición de los ítems de navegación
  final List<Map<String, dynamic>> _navItems = const [
    {
      'icon': Icons.qr_code_scanner_outlined,
      'label': 'Escanear',
      'index': 0,
      'screen': WelcomeScreen(),
    },
    {
      'icon': Icons.history,
      'label': 'Historial',
      'index': 1,
      'screen': HistoryScreen(),
    },
    {
      'icon': Icons.person_outline,
      'label': 'Perfil',
      'index': 2,
      'screen': SettingsScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Altura adecuada para los botones
      decoration: BoxDecoration(
        color: kMinimalBackground, // Fondo blanco roto
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        // Bordes opcionales en la parte superior si quieres suavizar la transición al cuerpo
        // borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ), // CORRECCIÓN: Se redujo de 8 a 7 para evitar el overflow.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _navItems.map((item) {
          final isSelected = item['index'] == currentIndex;
          return _buildNavItem(
            context,
            icon: item['icon'] as IconData,
            label: item['label'] as String,
            isSelected: isSelected,
            screen: item['screen'] as Widget,
          );
        }).toList(),
      ),
    );
  }

  // Widget para construir cada botón cuadrado minimalista
  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          // Usamos pushReplacement para evitar acumular pantallas en el stack
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => screen),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 55, // Ancho del botón cuadrado
            height: 45, // Altura del botón cuadrado
            decoration: BoxDecoration(
              color: isSelected
                  ? kPrimaryOrange.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12), // Bordes de 12
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? kPrimaryOrange
                  : Colors.black54, // Color de icono activo/inactivo
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? kPrimaryOrange : Colors.black54,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
