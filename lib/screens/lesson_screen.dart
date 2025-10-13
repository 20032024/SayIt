import 'package:flutter/material.dart';
// ✅ 1. Importa los modelos que necesitas
import 'package:project_sayit/models/subcategorie_model.dart';
import 'package:project_sayit/models/lesson_item_model.dart';
import 'evaluation_dialog.dart';

// ✅ 2. Convierte la clase en un StatefulWidget
class LessonScreen extends StatefulWidget {
  // Ahora recibe el objeto SubCategoria completo
  final SubCategoria subCategoria;

  const LessonScreen({super.key, required this.subCategoria});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

// ✅ 3. Crea la clase State que manejará los cambios
class _LessonScreenState extends State<LessonScreen> {
  // --- AQUÍ ESTÁ LA MAGIA ---
  // Esta variable "recuerda" la posición de la palabra actual
  int _currentIndex = 0;

  // Método para ir a la siguiente palabra
  void _siguientePalabra() {
    // Si no hemos llegado al final de la lista...
    if (_currentIndex < widget.subCategoria.lecciones.length - 1) {
      // setState() le dice a Flutter que redibuje la pantalla con el nuevo índice
      setState(() {
        _currentIndex++;
      });
    } else {
      // Opcional: Si es la última palabra, mostramos el diálogo de evaluación
      showEvaluationDialog(context);
    }
  }

  // Método para ir a la palabra anterior
  void _anteriorPalabra() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }
  // --- FIN DE LA LÓGICA DE ESTADO ---

  @override
  Widget build(BuildContext context) {
    // ✅ 4. Obtenemos la lección actual usando el _currentIndex
    final LessonItem leccionActual =
        widget.subCategoria.lecciones[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        leading: const LessonBackButton(),
        // Usamos el título de la subcategoría que recibimos
        title: Text(
          widget.subCategoria.titulo,
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
            // Mostramos la palabra de la lección actual
            Text(
              leccionActual.palabra,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            // Aquí podrías usar la imagen de leccionActual.imagenUrl
            _buildImageCard(imageUrl: leccionActual.imagenUrl),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.volume_up,
                  onPressed: () {
                    print(
                      'Botón de audio presionado para: ${leccionActual.palabra}',
                    );
                  },
                ),
                const SizedBox(width: 48),
                _buildActionButton(
                  icon: Icons.mic,
                  onPressed: () {
                    print(
                      'Botón de micrófono presionado para: ${leccionActual.palabra}',
                    );
                  },
                ),
              ],
            ),
            const Spacer(),
            // ✅ 5. Botones para navegar en la lección
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón para retroceder, se deshabilita si es la primera palabra
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 32,
                  onPressed: _currentIndex > 0 ? _anteriorPalabra : null,
                ),
                // Muestra el progreso actual
                Text(
                  '${_currentIndex + 1} / ${widget.subCategoria.lecciones.length}',
                  style: const TextStyle(fontSize: 18),
                ),
                // Botón para avanzar o finalizar
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  iconSize: 32,
                  onPressed: _siguientePalabra,
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  // --- TUS WIDGETS AUXILIARES (¡INTACTOS!) ---
  Widget _buildImageCard({required String imageUrl}) {
    return Container(
      width: double.infinity,
      height: 250,
      // ClipRRect asegura que la imagen tenga los bordes redondeados
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          imageUrl, // ✅ Usa la ruta del modelo directamente
          fit: BoxFit.cover, // Hace que la imagen cubra todo el espacio
          // Manejo de errores por si la imagen no se encuentra
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.error_outline, color: Colors.white, size: 64),
            );
          },
        ),
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
      // --- MODIFICACIÓN AQUÍ ---
      onPressed: () {
        // En lugar de navegar, ahora mostramos el diálogo
        showEvaluationDialog(context);
        print('Mostrando diálogo de evaluación...');
      },
      // --- FIN DE LA MODIFICACIÓN ---
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
