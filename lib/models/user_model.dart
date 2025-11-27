import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;

  UserModel({required this.uid, required this.email, required this.name});

  // Método para convertir el modelo a un Map, que es el formato que Firestore usa.
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      // No guardamos la contraseña aquí, solo los datos públicos.
      'createdAt': Timestamp.now(),
    };
  }

  // Método opcional para crear un modelo desde un documento de Firestore
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc.id,
      email: doc['email'] as String,
      name: doc['name'] as String,
    );
  }
}
