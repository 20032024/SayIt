import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_sayit/models/signal_description.dart'; // Contiene signalDetails

// ⚠️ Definiciones de Color coherentes con el resto de la aplicación
const Color kPrimaryOrange = const Color.fromARGB(170, 255, 112, 2);
const Color kMinimalBackground = Color(0xFFF5F5F5); // Fondo minimalista
const Color kTextDark = Color(0xFF2E3D49); // Color de texto oscuro

class SignalDetailScreen extends StatelessWidget {
  final String signalId;
  final String signalName;
  final File imageFile;

  const SignalDetailScreen({
    super.key,
    required this.signalId,
    required this.signalName,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    // Busca la información en tu mapa (asumiendo que está definido en signal_description.dart)
    final detail = signalDetails[signalId];

    return Scaffold(
      // 1. FONDO MINIMALISTA
      backgroundColor: kMinimalBackground,
      appBar: AppBar(
        // AppBar transparente sobre el fondo minimalista
        backgroundColor: kMinimalBackground,
        elevation: 0,
        // Icono oscuro para el fondo claro
        iconTheme: const IconThemeData(color: kTextDark),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. TÍTULO PRINCIPAL
                  Text(
                    signalName,
                    style: TextStyle(
                      color: kTextDark,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 3. IMAGEN CAPTURADA
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Bordes redondeados
                    child: Container(
                      decoration: BoxDecoration(
                        // Sombra sutil para destacar la imagen
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Image.file(
                        imageFile,
                        height: 500, // Altura moderada
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 4. SIGNIFICADO (Énfasis)
                  Text(
                    'Significado:',
                    style: TextStyle(
                      color: const Color.fromARGB(170, 255, 112, 2),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    detail?["meaning"] ?? "Sin información",
                    style: TextStyle(color: kTextDark, fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  // 5. DESCRIPCIÓN
                  Text(
                    'Descripción Detallada:',
                    style: TextStyle(
                      color: kTextDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    detail?["description"] ?? "Sin descripción disponible",
                    style: TextStyle(
                      color: kTextDark.withOpacity(
                        0.8,
                      ), // Texto ligeramente más claro
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // 6. BOTÓN DE ACCIÓN FIJO (Minimalista y Funcional)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Vuelve a la pantalla de cámara o menú principal
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(170, 255, 112, 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Volver a escanear',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
