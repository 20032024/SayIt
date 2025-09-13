import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding opcional para el espaciado.
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 1. Botón de Registrarse (Acción principal)
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
              // TODO: Implementa tu lógica de registro.
              // Después del registro, puedes navegar a la pantalla de inicio o login.
              // Ejemplo: Navigator.pop(context); para volver al login.
              print('Botón "Registrarse" presionado');
            },
            child: const Text('Registrarse', style: TextStyle(fontSize: 16)),
          ),

          const SizedBox(height: 16),

          // 2. Enlace para volver a Iniciar Sesión
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("¿Ya tienes una cuenta?"),
              TextButton(
                onPressed: () {
                  // TODO: Navegar de vuelta a la pantalla de Login.
                  // La forma más común es simplemente cerrar la pantalla actual.
                  // Ejemplo:
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  print('Botón "Inicia Sesión" presionado');
                },
                child: const Text('Inicia Sesión'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
