import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Inicia el proceso de Google Sign-In y obtiene las credenciales de Firebase.
  ///
  /// Retorna un objeto UserCredential si es exitoso, o null si el usuario cancela.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Iniciar el flujo de Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Si el usuario cancela el inicio de sesión, googleUser será null.
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
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // Manejo de errores específicos de Firebase (e.g., cuenta deshabilitada)
      print("Error de Firebase Auth al iniciar sesión con Google: $e");
      return null;
    } catch (e) {
      // Manejo de otros errores (e.g., problemas de red)
      print("Error desconocido al iniciar sesión con Google: $e");
      return null;
    }
  }

  /// Cierra la sesión de Firebase y Google.
  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      // signOut solo es relevante en plataformas nativas, no web
      await _googleSignIn.signOut();
    }
  }
}
