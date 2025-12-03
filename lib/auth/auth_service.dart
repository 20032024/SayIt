import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_sayit/models/user_model.dart'; // Importa el modelo de datos

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Instancia de Firestore para interactuar con la base de datos
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // =========================================================
  // FUNCIÓN AUXILIAR: GUARDAR DATOS DEL USUARIO EN FIRESTORE
  // =========================================================
  /// Guarda el email y el nombre del usuario en la colección 'usuarios' de Firestore.
  /// Usa el UID del usuario (generado por Firebase Auth) como ID del documento.
  Future<void> _saveUserToFirestore(
    String uid,
    String email,
    String name,
  ) async {
    final UserModel newUser = UserModel(uid: uid, email: email, name: name);

    // Guarda el documento en la colección 'usuarios'
    return _db.collection('usuarios').doc(uid).set(newUser.toMap());
  }

  // =========================================================
  // REGISTRO CON EMAIL Y CONTRASEÑA
  // =========================================================
  /// Crea una cuenta de usuario en Firebase Auth y guarda su perfil en Firestore.
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name, // Se requiere el nombre para guardarlo en Firestore
  }) async {
    try {
      // 1. Crear la cuenta en Firebase Auth
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. GUARDAR DATOS EN FIRESTORE si la autenticación fue exitosa
      if (credential.user != null) {
        await _saveUserToFirestore(credential.user!.uid, email, name);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code}');
      // Manejo de errores de autenticación
      return null;
    } catch (e) {
      print('Error de registro: $e');
      return null;
    }
  }

  // =========================================================
  // LOGIN CON GOOGLE
  // =========================================================
  /// Inicia el proceso de Google Sign-In y obtiene las credenciales de Firebase.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Iniciar el flujo de Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      // 2. Obtener los detalles de autenticación de Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Crear una credencial de Firebase con el token de Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Iniciar sesión en Firebase con la credencial de Google
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Nota: Si el usuario es nuevo, deberías guardarlo en Firestore aquí también.

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Error de Firebase Auth al iniciar sesión con Google: $e");
      return null;
    } catch (e) {
      print("Error desconocido al iniciar sesión con Google: $e");
      return null;
    }
  }

  /// Cierra la sesión de Firebase y Google.
  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
  }
}
