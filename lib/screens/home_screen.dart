import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';
import 'package:project_sayit/app_styles.dart';
import 'package:project_sayit/screens/camara_screen.dart';

// ⚠️ Definiciones de Color para asegurar el estilo de HistoryScreen
const Color kPrimaryOrange = Color(
  0xFFF08C69,
); // Usado en HistoryScreen como primaryColor
const Color kMinimalBackground = Color(
  0xFFF5F5F5,
); // Usado en HistoryScreen como backgroundColor

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🎯 APLICANDO EL NUEVO FONDO MINIMALISTA
      backgroundColor: kMinimalBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título principal
                Text(
                  '¡Bienvenido a nuestra App!',
                  style: kTitleStyle.copyWith(
                    color: Colors.black87,
                  ), // Asegura buena legibilidad en fondo claro
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Subtítulo
                // Si kTextDark es negro, funcionará bien con el fondo claro.
                Text(
                  'Empecemos a escanear las señales de tráfico',
                  style: kBodyTextStyle.copyWith(color: kTextDark),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Botón principal
                GestureDetector(
                  onTap: () {
                    // Aquí va la acción, por ejemplo:
                    // Navigator.pushNamed(context, '/resnet');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CamaraScreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          // Mantenemos el color secundario, asumiendo que kSecondaryYellow se ve bien
                          color: kSecondaryYellow,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Presiona para escanear e\nidentificar la señal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kPrimaryOrange, // Usando el color principal
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // navbar
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}
