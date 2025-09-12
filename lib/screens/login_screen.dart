import 'package:flutter/material.dart';
import 'package:project_sayit/screens/signup_screen.dart'; // Importa tu pantalla de registro
import 'package:project_sayit/screens/home_screen.dart'; // Importa la pantalla de inicio
import 'package:project_sayit/screens/detail_screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding opcional para dar un poco de espacio alrededor de los botones.
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 1. Botón de Iniciar Sesión (Acción principal)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.blue, // Color primario
              foregroundColor: Colors.white, // Texto en blanco
            ),
            onPressed: () {
              // Navega a HomeScreen y reemplaza LoginScreen en la pila de navegación.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriesScreen(),
                ),
              );
              print('Botón "Iniciar Sesión" presionado, navegando a Home');
            },
            child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 16)),
          ),

          const SizedBox(height: 12),

          // 2. Botón de Olvidar Contraseña (Acción secundaria)
          TextButton(
            onPressed: () {
              // TODO: Navegar a la pantalla de recuperar contraseña.
              // Ejemplo: Navigator.pushNamed(context, '/forgot-password');
              print('Botón "¿Olvidaste tu contraseña?" presionado');
            },
            child: const Text('¿Olvidaste tu contraseña?'),
          ),

          const SizedBox(height: 20),

          // 3. Botón de Registrarse (Acción alternativa)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(
                color: Colors.blue,
              ), // Borde del color primario
            ),
            // CÓDIGO CORRECTO
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ), // O el nombre de tu clase de registro
              );
              print('Botón "Registrarse" presionado');
            },
            child: const Text('Registrarse', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
