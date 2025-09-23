import 'package:flutter/material.dart';
import '../app_styles.dart'; // Importamos nuestros estilos
import 'home_screen.dart'; // <-- AGREGA ESTA LÍNEA

class LessonSummaryScreen extends StatelessWidget {
  // Le ponemos un constructor const para mejor rendimiento
  const LessonSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold es el esqueleto básico de una pantalla
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        // --- INICIO DE LA MODIFICACIÓN ---
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kTextDark),
          onPressed: () {
            // Esta es la acción que te regresa a la pantalla anterior
            Navigator.pop(context); 
          },
        ),
        // --- FIN DE LA MODIFICACIÓN ---
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        // Padding para que el contenido no esté pegado a los bordes
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          // Column apila los widgets verticalmente
          mainAxisAlignment: MainAxisAlignment.center, // Centramos el contenido verticalmente
          crossAxisAlignment: CrossAxisAlignment.stretch, // Estiramos el contenido horizontalmente
          children: [
            const Text(
              "Finished",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: kTextLight),
            ),
            const SizedBox(height: 16),
            const Text(
              "¡Felicidades! terminaste esta categoría.",
              textAlign: TextAlign.center,
              style: kTitleStyle,
            ),
            const SizedBox(height: 8),
            const Text(
              "Esta es tu calificación final.",
              textAlign: TextAlign.center,
              style: kBodyTextStyle,
            ),
            const SizedBox(height: 40),
            
            // El puntaje grande y verde
            const Text(
              "97%",
              textAlign: TextAlign.center,
              style: kBigScoreStyle,
            ),
            
            const SizedBox(height: 40),
            const Text(
              "Ahora puedes continuar con una nueva lección.",
              textAlign: TextAlign.center,
              style: kBodyTextStyle,
            ),

            // Spacer ocupa todo el espacio vertical disponible para empujar los botones hacia abajo
            const Spacer(), 

            // Botón principal
            ElevatedButton(
              onPressed: () {
                // Aquí iría la lógica para ir a la siguiente lección
                print("Botón 'Siguiente lección' presionado");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Siguiente lección',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Botón secundario
            ElevatedButton(
              onPressed: () {
                // Navega al HomeScreen y borra todas las pantallas anteriores.
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoriesScreen()), // Reemplaza HomeScreen() si tu widget se llama diferente
                  (Route<dynamic> route) => false, // Esta condición borra todo el historial
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryYellow,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Ir al inicio',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40), // Un poco de espacio al final
          ],
        ),
      ),
    );
  }
}