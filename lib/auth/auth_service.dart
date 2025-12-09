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

  // ⚠️ Asegura que siempre haya un usuario logueado (anónimo o registrado)
  Future<User> ensureUserIsLoggedIn() async {
    User? user = _auth.currentUser;
    if (user == null) {
      // Intenta iniciar sesión anónimamente si no hay usuario
      final userCredential = await _auth.signInAnonymously();
      user = userCredential.user;
    }
    if (user == null) {
      throw Exception("No se pudo obtener ni crear un usuario para la sesión.");
    }
    return user;
  }

  // =========================================================
  // FUNCIÓN AUXILIAR: GUARDAR DATOS DEL USUARIO EN FIRESTORE
  // =========================================================
  /// Guarda el email y el nombre del usuario en la colección 'usuarios' de Firestore.
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
  // REGISTRO CON EMAIL Y CONTRASEÑA (¡CORREGIDO!)
  // =========================================================
  /// Crea una cuenta de usuario en Firebase Auth y guarda su perfil en Firestore.
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // 1. Crear la cuenta en Firebase Auth
      // 🚨 CORRECCIÓN: Usar createUserWithEmailAndPassword para REGISTRAR
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. GUARDAR DATOS EN FIRESTORE si la autenticación fue exitosa
      if (credential.user != null) {
        await _saveUserToFirestore(credential.user!.uid, email, name);

        // 🚀 Forzar la recarga del objeto de usuario
        await credential.user!.reload();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code}');
      // Manejo de errores de autenticación (ej. email-already-in-use)
      return null;
    } catch (e) {
      print('Error de registro: $e');
      return null;
    }
  }

  // =========================================================
  // LOGIN CON EMAIL Y CONTRASEÑA (AÑADIDO)
  // =========================================================
  /// Inicia sesión con el email y contraseña.
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Llama a la función de Firebase Auth para INICIAR SESIÓN
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.reload();
      return credential;
    } on FirebaseAuthException catch (e) {
      // Manejo de errores (ej. user-not-found, wrong-password)
      print('Firebase Auth Error durante el login: ${e.code}');
      return null;
    } catch (e) {
      print('Error desconocido durante el login: $e');
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

      // Si el usuario es nuevo, deberías guardarlo en Firestore aquí también.
      if (userCredential.user != null) {
        // 🚀 Forzar la recarga del objeto de usuario
        await userCredential.user!.reload();
      }

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

  /// Retorna el usuario de Firebase Auth actualmente autenticado.
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
