import 'package:flutter/material.dart';
import 'package:project_sayit/screens/settings_screen.dart';
import 'package:project_sayit/screens/detail_screens.dart'; // Import the DetailScreen
import 'package:project_sayit/screens/lesson_screen.dart';
import 'custom_bottom_nav.dart';
import 'package:project_sayit/models/subcategorie_model.dart';
import 'package:project_sayit/models/categorie_model.dart';
import 'package:project_sayit/models/lesson_item_model.dart';
import 'package:project_sayit/data/data_categories.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Proyecto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar section
            const TextField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Filter buttons section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: const Text(
                      'TODO',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: const Text('EN CURSO'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: const Text('FINALIZADOS'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Categories content
            // ----- ✅ AÑADE ESTE NUEVO WIDGET EN SU LUGAR ✅ -----
            Expanded(
              child: ListView.builder(
                itemCount: categoriasData.length,
                itemBuilder: (context, index) {
                  final categoria = categoriasData[index];
                  return _buildCategorySection(context, categoria: categoria);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  // ----- ✅ AÑADE ESTOS DOS NUEVOS MÉTODOS ✅ -----

  // 1. Este método crea la sección de la CATEGORÍA PRINCIPAL (ej: "Animales")
  Widget _buildCategorySection(
    BuildContext context, {
    required Categoria categoria,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            categoria.titulo,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        // Crea una lista de widgets de SubCategoría a partir de los datos
        ...categoria.subCategorias.map((subCategoria) {
          return _buildSubCategorySection(context, subCategoria: subCategoria);
        }).toList(),
      ],
    );
  }

  // 2. Este método crea la sección de la SUBCATEGORÍA (ej: "Domésticos")
  Widget _buildSubCategorySection(
    BuildContext context, {
    required SubCategoria subCategoria,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subCategoria.titulo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Ver más',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount: subCategoria.lecciones.length,
          itemBuilder: (context, index) {
            final lessonItem = subCategoria.lecciones[index];
            return CategoryCard(
              subCategoria: subCategoria,
              lessonItem: lessonItem,
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ----- ✅ Y AÑADE ESTA NUEVA VERSIÓN EN SU LUGAR ✅ -----
class CategoryCard extends StatelessWidget {
  // ✅ CORREGIDO: Ahora está en singular
  final SubCategoria subCategoria;
  final LessonItem lessonItem;

  const CategoryCard({
    super.key,
    // ✅ CORREGIDO: El constructor también está en singular
    required this.subCategoria,
    required this.lessonItem,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ AHORA FUNCIONA: Porque la variable 'subCategoria' sí existe
    final String progressText =
        '${subCategoria.progresoActual}/${subCategoria.progresoTotal}';
    final double progressValue =
        subCategoria.progresoActual / subCategoria.progresoTotal;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              // ✅ AHORA FUNCIONA
              categoryName: subCategoria.titulo,
              progress: progressText,
              description: lessonItem.descripcion,
              word: lessonItem.palabra,
            ),
          ),
        );
      },
      child: Card(
        // ... El resto de tu código del Card se queda igual ...
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD54F),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 50, color: Color(0xFFC5AE79)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lessonItem.palabra,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    progressText,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: const Color(0xFFF0F0F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.orange,
                    ),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
