import 'package:flutter/material.dart';
import 'package:project_sayit/screens/settings_screen.dart';

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
            // Sección de la barra de búsqueda
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

            // Sección de los botones de filtro
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

            // Contenido de las categorías
            Expanded(
              child: ListView(
                children: [
                  // Categoría 1
                  _buildCategorySection(
                    context,
                    title: 'Nombre Categoría',
                    items:
                        4, // Puedes ajustar este número para ver más o menos tarjetas
                  ),
                  const SizedBox(height: 16),

                  // Categoría 2
                  _buildCategorySection(
                    context,
                    title: 'Otra Categoría',
                    items: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Categorías'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
        ],
        onTap: (index) {
          if (index == 1) {
            // Navega a la pantalla de Settings
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context, {
    required String title,
    required int items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
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
          shrinkWrap:
              true, // Importante para que funcione dentro de un ListView
          physics:
              const NeverScrollableScrollPhysics(), // Evita el scroll anidado
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columnas
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8, // Proporción de aspecto para las tarjetas
          ),
          itemCount: items,
          itemBuilder: (context, index) {
            // Crea una tarjeta por cada elemento
            return const CategoryCard();
          },
        ),
      ],
    );
  }
}

// Widget de la tarjeta de categoría
class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Espacio para la imagen
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
          // Contenido de texto y barra de progreso
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nombre',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('1/20', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                const LinearProgressIndicator(
                  value: 0.05, // Valor de progreso (5%)
                  backgroundColor: Color(0xFFF0F0F0),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  minHeight: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
