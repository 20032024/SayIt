// auth_check_screen.dart (Nuevo archivo)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Asumo que tienes una pantalla de bienvenida después del login
import 'package:project_sayit/screens/home_screen.dart';
// Asumo que tienes una pantalla de login separada
import 'package:project_sayit/screens/login_screen.dart';

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔑 CLAVE: El StreamBuilder escucha los cambios de estado de Firebase Auth.
    // Esto maneja la renovación automática del token y la persistencia de la sesión.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. Estado de Conexión
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras Firebase verifica
          // si existe una sesión persistente o si el token necesita renovarse.
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          );
        }

        // 2. Usuario Autenticado (Sesión Persistente)
        // snapshot.hasData es verdadero si Firebase encuentra un usuario activo.
        if (snapshot.hasData) {
          // El usuario está logueado y el token fue renovado automáticamente.
          // Llevar al usuario a la pantalla principal sin pasar por el login.
          return const WelcomeScreen();
        }
        // 3. Usuario Deslogueado (Token expiró sin refresco o cerró sesión)
        else {
          // El usuario no está logueado. Mostrar la pantalla de login/registro.
          return const LoginScreen();
        }
      },
    );
  }
}
