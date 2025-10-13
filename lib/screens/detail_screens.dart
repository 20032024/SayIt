import 'package:flutter/material.dart';
import 'package:project_sayit/models/subcategorie_model.dart'; // ✅ Importa el modelo
import 'package:project_sayit/screens/lesson_screen.dart';

class DetailScreen extends StatelessWidget {
  // ✅ Ahora recibe el objeto SubCategoria completo
  final SubCategoria subCategoria;

  const DetailScreen({super.key, required this.subCategoria});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildImageSection(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildLessonInfoSection(),
                        const SizedBox(height: 16),
                        _buildDescriptionSection(),
                        const SizedBox(height: 24),
                        _buildBottomButtons(context),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Positioned(top: 40, left: 16, child: CloseDetailButton()),
        ],
      ),
    );
  }

  // Los métodos auxiliares se mantienen iguales, pero ahora usan los parámetros.
  Widget _buildImageSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: const BoxDecoration(
        color: Color(0xFFFFC673),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const Center(child: Icon(Icons.image, size: 80, color: Colors.white)),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => _buildDotIndicator(index == 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF18F42) : Colors.white54,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildLessonInfoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Usa el título del modelo
            Text(
              subCategoria.titulo,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // ✅ Calcula el progreso desde el modelo
            Text(
              '${subCategoria.progresoActual}/${subCategoria.progresoTotal} lecciones',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(Icons.check, color: Color(0xFF616161)),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descripción',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          subCategoria.descripcion,
          style: const TextStyle(fontSize: 16, color: Color(0xFF616161)),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ✅ Pasa el objeto completo al botón
        Expanded(child: StartLessonButton(subCategoria: subCategoria)),
      ],
    );
  }
}

// Botón para comenzar la lección
// El botón ahora recibe el objeto SubCategoria
class StartLessonButton extends StatelessWidget {
  final SubCategoria subCategoria;

  const StartLessonButton({super.key, required this.subCategoria});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // ✅ Pasa el objeto completo a LessonScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonScreen(subCategoria: subCategoria),
          ),
        );
      },
      style: ElevatedButton.styleFrom(/* ... tu estilo ... */),
      child: const Text(
        'Comenzar lección',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Botón para cerrar la pantalla
class CloseDetailButton extends StatelessWidget {
  const CloseDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close, size: 30.0),
      onPressed: () {
        Navigator.pop(context);
        print('Retrocediendo a la pantalla anterior...');
      },
    );
  }
}
