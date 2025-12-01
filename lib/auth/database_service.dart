import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método simplificado: SOLO guarda datos de texto
  Future<void> saveDetection({
    required String signResult, // El nombre del insecto
    required double confidence, // Probabilidad
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null)
        return; // Si no hay usuario, no guardamos nada (o lanzamos error)

      // Guardamos solo el registro en Firestore
      await _db.collection('history').add({
        'userId': user.uid,
        'userEmail': user.email,
        'signtName': signResult,
        'confidence': confidence,
        'timestamp':
            FieldValue.serverTimestamp(), // La fecha y hora exactas del servidor
        'type': 'text_log_only', // (Opcional) Para saber que no hay foto
      });

      print("✅ Registro guardado en historial (Sin imagen)");
    } catch (e) {
      print("❌ Error al guardar registro: $e");
      rethrow;
    }
  }

  // Obtener historial (Sin cambios, solo traerá datos de texto)
  Stream<QuerySnapshot> getUserHistory() {
    final user = _auth.currentUser;
    if (user != null) {
      return _db
          .collection('history')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  Future<void> deleteDetection(String docId) async {
    try {
      await _db.collection('history').doc(docId).delete();
    } catch (e) {
      print("Error al eliminar: $e");
      rethrow;
    }
  }
}