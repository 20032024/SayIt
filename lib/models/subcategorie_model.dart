//import 'lesson_item_model.dart';
import 'package:project_sayit/models/lesson_item_model.dart';

class SubCategoria {
  final String titulo;
  final int progresoActual;
  final String descripcion;
  final int progresoTotal;
  final List<LessonItem> lecciones; // ¡Aquí está la magia!

  SubCategoria({
    required this.titulo,
    required this.progresoActual,
    required this.descripcion,
    required this.progresoTotal,
    required this.lecciones,
  });
}
