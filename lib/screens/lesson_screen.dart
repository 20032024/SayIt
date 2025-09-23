import 'package:flutter/material.dart';

// --- PANTALLA DE RESULTADOS (EJEMPLO) ---
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Volver a la Lección'),
        ),
      ),
    );
  }
}

// --- PANTALLA DE LA LECCIÓN (CON PARÁMETROS) ---
class LessonScreen extends StatelessWidget {
  // Los parámetros de la categoría y la palabra
  final String categoryName;
  final String word;

  const LessonScreen({
    super.key,
    required this.categoryName,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LessonBackButton(),
        title: Text(
          categoryName, // Usa el parámetro de categoría
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              word, // Usa el parámetro de la palabra
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            _buildImageCard(),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.volume_up,
                  onPressed: () {
                    print('Botón de audio presionado para: $word');
                  },
                ),
                const SizedBox(width: 48),
                _buildActionButton(
                  icon: Icons.mic,
                  onPressed: () {
                    print('Botón de micrófono presionado para: $word');
                  },
                ),
              ],
            ),
            const Spacer(),
            const SubmitLessonButton(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  // Los widgets auxiliares se mantienen iguales
  Widget _buildImageCard() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0xFFFFC673),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: const Center(
        child: Icon(Icons.image, size: 64, color: Colors.white),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(24),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        side: const BorderSide(color: Color(0xFFF18F42), width: 1.5),
      ),
      child: Icon(icon, size: 36, color: const Color(0xFFF18F42)),
    );
  }
}

// --- WIDGETS DE NAVEGACIÓN ---
class LessonBackButton extends StatelessWidget {
  const LessonBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      onPressed: () {
        Navigator.pop(context);
        print('Retrocediendo a la pantalla de detalle...');
      },
    );
  }
}

class SubmitLessonButton extends StatelessWidget {
  const SubmitLessonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
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

// --- EJEMPLO DE CÓMO LLAMAR A LA PANTALLA ---
// Puedes usar un código como este para navegar a la LessonScreen.
// Reemplaza los datos con la información real de tu lección.
/*
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LessonScreen(
          categoryName: 'Frutas',
          word: 'Apple',
        ),
      ),
    );
  },
  child: const Text('Ir a la Lección de Frutas'),
);
*/
