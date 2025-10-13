import 'package:flutter/material.dart';
import 'package:project_sayit/models/categorie_model.dart';
import 'package:project_sayit/screens/lesson_screen.dart';
import 'package:project_sayit/screens/detail_screens.dart';

class SubCategoriesScreen extends StatelessWidget {
  // Recibe la categoría seleccionada
  final Categoria categoria;

  const SubCategoriesScreen({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoria.titulo), // Muestra el título, ej: "Animales"
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: categoria.subCategorias.length,
        itemBuilder: (context, index) {
          final subCategoria = categoria.subCategorias[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12.0),
              title: Text(
                subCategoria.titulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Progreso: ${subCategoria.progresoActual}/${subCategoria.progresoTotal}',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(subCategoria: subCategoria),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
