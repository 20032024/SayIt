import 'package:project_sayit/models/categorie_model.dart';
import 'package:project_sayit/models/subcategorie_model.dart';
import 'package:project_sayit/models/lesson_item_model.dart';

final List<Categoria> categoriasData = [
  // --- CATEGORÍA PRINCIPAL: ANIMALES ---
  Categoria(
    titulo: 'Animales',
    subCategorias: [
      // --- SubCategoría 1.1 ---
      SubCategoria(
        titulo: 'Domésticos',
        progresoActual: 5,
        progresoTotal: 10,
        lecciones: [
          LessonItem(
            palabra: 'Gato',
            imagenUrl: 'assets/images/cat.png',
            descripcion: '...',
          ),
          LessonItem(
            palabra: 'Perro',
            imagenUrl: 'assets/images/dog.png',
            descripcion: '...',
          ),
          LessonItem(
            palabra: 'Hámster',
            imagenUrl: 'assets/images/hamster.png',
            descripcion: '...',
          ),
        ],
      ),
      // --- SubCategoría 1.2 ---
      SubCategoria(
        titulo: 'Salvajes',
        progresoActual: 1,
        progresoTotal: 20,
        lecciones: [
          LessonItem(
            palabra: 'León',
            imagenUrl: 'assets/images/lion.png',
            descripcion: '...',
          ),
          LessonItem(
            palabra: 'Tigre',
            imagenUrl: 'assets/images/tiger.png',
            descripcion: '...',
          ),
          LessonItem(
            palabra: 'Oso',
            imagenUrl: 'assets/images/bear.png',
            descripcion: '...',
          ),
          LessonItem(
            palabra: 'Elefante',
            imagenUrl: 'assets/images/elephant.png',
            descripcion: '...',
          ),
        ],
      ),
    ],
  ),
  // --- CATEGORÍA PRINCIPAL: FRUTAS ---
  Categoria(
    titulo: 'Frutas',
    subCategorias: [
      // --- SubCategoría 2.1 ---
      SubCategoria(
        titulo: 'Cítricas',
        progresoActual: 2,
        progresoTotal: 5,
        lecciones: [
          LessonItem(
            palabra: 'Naranja',
            imagenUrl: 'assets/images/orange.png',
            descripcion: '...',
          ),
          LessonItem(
            palabra: 'Limón',
            imagenUrl: 'assets/images/lemon.png',
            descripcion: '...',
          ),
        ],
      ),
    ],
  ),
];
