import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Logo o Icono de la App
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFEEBC7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(15.0), // Ajusta este número si quieres la imagen más grande o pequeña
                  child: Image.asset(
                    'assets/images/LogoSnapSign.png', // <--- AQUÍ VA EL NOMBRE EXACTO DE TU ARCHIVO
                    fit: BoxFit.contain, // Esto asegura que la imagen se vea completa sin estirarse
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'SnapSign',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF374151),
              ),
            ),
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'SnapSign es una aplicación enfocada al reconocimiento de señales de tráfico, diseñada para ayudar a los conductores a identificar y comprender mejor las señales viales mediante el uso de tecnología avanzada de reconocimiento de imágenes. Nuestra misión es mejorar la seguridad vial y proporcionar una herramienta útil para todos los conductores. Con SnapSign, puedes capturar imágenes de señales de tráfico y obtener información detallada sobre su significado y relevancia en tiempo real. Ya sea que seas un conductor experimentado o un principiante, SnapSign está aquí para asistirte en tu viaje por las carreteras. ¡Conduce con confianza y seguridad con SnapSign!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            const Text(
              '© 2025 SnapSign Team',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}