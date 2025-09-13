import 'package:flutter/material.dart';

// --- PANTALLA DE LECCIÓN (EJEMPLO) ---
// Esta es la pantalla a la que avanzas.
class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Flutter también añade aquí una flecha de retroceso automáticamente.
        title: const Text('Lección en Curso'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Usa Navigator.pop para volver a la pantalla de detalle.
            Navigator.pop(context);
          },
          child: const Text('Terminar y Retroceder'),
        ),
      ),
    );
  }
}

// --- BOTÓN #1: COMENZAR LECCIÓN (AVANZAR) ---
// Este es el botón principal en la parte inferior de la pantalla.
class StartLessonButton extends StatelessWidget {
  const StartLessonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // 'Navigator.push' se usa para abrir la nueva pantalla 'LessonScreen'.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LessonScreen()),
          );
          print('Avanzando a la pantalla de lección...');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF18F42),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Comenzar lección',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// --- BOTÓN #2: CERRAR (RETROCEDER) ---
// Este es el IconButton en la esquina superior izquierda de la imagen.
class CloseDetailButton extends StatelessWidget {
  const CloseDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close, size: 30.0),
      onPressed: () {
        // 'Navigator.pop' cierra la pantalla actual (DetailScreen)
        // y regresa a la pantalla que la abrió (HomeScreen).
        Navigator.pop(context);
        print('Retrocediendo a la pantalla anterior...');
      },
    );
  }
}
