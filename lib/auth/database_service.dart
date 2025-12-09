import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Colección raíz donde se almacenan los usuarios
  static const String _usersCollection = 'usuarios';
  // Subcolección donde se almacena el historial de cada usuario
  static const String _historySubCollection = 'history';

  // ----------------------------------------------------
  //                 OPERACIONES DE ESCRITURA (CREATE/DELETE)
  // ----------------------------------------------------

  // 💾 Guarda un nuevo registro de detección en la subcolección de historial del usuario.
  Future<void> saveDetection({
    required String signResult,
    required double confidence,
    required String signalId,
    required String iconPath,
    required imageHash,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Usuario no autenticado para guardar historial.");
    }

    try {
      // RUTA DE ESCRITURA SEGURA: /usuarios/{UID}/history/{documentId}
      final historyCollectionRef = _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .collection(_historySubCollection);

      await historyCollectionRef.add({
        'signName': signResult,
        'confidence': confidence,
        'signalId': signalId,
        'iconPath': iconPath,
        'timestamp': FieldValue.serverTimestamp(),
        'imageHash': imageHash,
      });

      print(
        '✅ Historial guardado en: $_usersCollection/${user.uid}/$_historySubCollection',
      );
    } catch (e) {
      print('❌ Error al guardar historial en Firestore: $e');
      rethrow;
    }
  }

  // 🗑️ Elimina un registro de historial específico por su ID de documento.
  Future<void> deleteDetection(String docId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Usuario no autenticado para eliminar historial.");
    }

    try {
      // RUTA DE ELIMINACIÓN SEGURA: /usuarios/{UID}/history/{docId}
      final docRef = _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .collection(_historySubCollection)
          .doc(docId);

      await docRef.delete();
      print(
        '🗑️ Registro eliminado: $_usersCollection/${user.uid}/$_historySubCollection/$docId',
      );
    } catch (e) {
      print('❌ Error al eliminar registro ($docId): $e');
      rethrow;
    }
  }

  // ----------------------------------------------------
  //                 OPERACIÓN DE LECTURA (READ)
  // ----------------------------------------------------

  // 📖 Obtiene el stream del historial del usuario actual (para StreamBuilder).
  Stream<QuerySnapshot> getUserHistory() {
    final user = _auth.currentUser;
    if (user == null) {
      // ⚠️ CORRECCIÓN CLAVE: Devolver un stream que inmediatamente emite un QuerySnapshot vacío
      // y que no lanza errores de construcción interna.
      return const Stream.empty(); // Devuelve un stream vacío que cumple con el tipo.
    }

    // RUTA DE LECTURA SEGURA: /usuarios/{UID}/history
    return _firestore
        .collection(_usersCollection)
        .doc(user.uid)
        .collection(_historySubCollection)
        // Opcional: Ordenar por fecha de forma descendente (más reciente primero)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
