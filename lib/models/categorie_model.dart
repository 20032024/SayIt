//import 'subcategorie_model.dart'; // ¡Importante! Cambiamos la importación
import 'package:project_sayit/models/subcategorie_model.dart';

class Categoria {
  final String titulo;
  final List<SubCategoria> subCategorias; // ¡Este es el cambio clave!

  Categoria({required this.titulo, required this.subCategorias});
}
