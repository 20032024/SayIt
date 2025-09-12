import 'package:flutter/material.dart';

// --- PANTALLA DE RESULTADOS (EJEMPLO) ---
// Esta es la pantalla a la que podrías avanzar después de "Enviar".
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Usa Navigator.pop para volver a la pantalla de la lección.
            Navigator.pop(context);
          },
          child: const Text('Volver a la Lección'),
        ),
      ),
    );
  }
}

// --- BOTÓN #1: ENVIAR (AVANZAR) ---
// Este es el botón principal en la parte inferior de la pantalla.
class SubmitLessonButton extends StatelessWidget {
  const SubmitLessonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 'Navigator.push' abre una nueva pantalla, como una de resultados.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResultsScreen()),
        );
        print('Avanzando a la siguiente pantalla...');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF18F42),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: const Text(
        'Enviar',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// --- BOTÓN #2: FLECHA DE REGRESO (RETROCEDER) ---
// Este es el IconButton en la AppBar para volver a la pantalla anterior.
class LessonBackButton extends StatelessWidget {
  const LessonBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      onPressed: () {
        // 'Navigator.pop' cierra la pantalla actual (LessonScreen)
        // y regresa a la que la llamó (DetailScreen).
        Navigator.pop(context);
        print('Retrocediendo a la pantalla de detalle...');
      },
    );
  }
}
