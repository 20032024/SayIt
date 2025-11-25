import 'package:flutter/material.dart';
import 'package:project_sayit/screens/signup_screen.dart'; // Importa tu pantalla de registro
import 'package:project_sayit/screens/home_screen.dart'; // Importa tu pantalla de categorías (home)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_sayit/auth/auth_service.dart'; // Importamos nuestro servicio

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService(); // Instancia del servicio
  // Define los colores del gradiente y el color principal del diseño
  final Color _startGradientColor = const Color(0xFFFFCC80); // Naranja claro
  final Color _endGradientColor = const Color(0xFFFF9800); // Naranja oscuro
  final Color _primaryColor = const Color(0xFFFF9800);

  // Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controla la visibilidad de la contraseña
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Estado para manejar el loading

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // LOGICA DE AUTENTICACIÓN
  // =========================================================

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    // Llama al servicio de autenticación para iniciar sesión con Google
    final UserCredential? userCredential = await _authService
        .signInWithGoogle();

    if (mounted) {
      setState(() {
        _isLoading = false; // Ocultar indicador de carga
      });

      if (userCredential != null) {
        // Éxito: Navegar a la pantalla principal
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      } else {
        // Manejar el caso de cancelación o error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inicio de sesión con Google cancelado o fallido.'),
            ),
          );
        }
      }
    }
  }

  // =========================================================
  // WIDGETS AUXILIARES
  // =========================================================

  // Widget para crear un campo de texto genérico (AJUSTADO PARA EL FONDO NARANJA)
  Widget _buildTextField(
    TextEditingController controller, {
    String hintText = '',
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white), // Color de texto blanco
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.black.withOpacity(
          0.15,
        ), // Fondo semitransparente oscuro
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Widget para crear un campo de contraseña (AJUSTADO PARA EL FONDO NARANJA)
  Widget _buildPasswordField(
    TextEditingController controller,
    String hintText,
  ) {
    return TextField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(color: Colors.white), // Color de texto blanco
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.black.withOpacity(
          0.15,
        ), // Fondo semitransparente oscuro
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  // 🌟 WIDGET PARA EL BOTÓN DE GOOGLE
  Widget _buildGoogleSignInButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      // Icono de Google (usando una URL para la imagen SVG)
      icon: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/2048px-Google_%22G%22_logo.svg.png',
        height: 24.0,
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87, // Texto oscuro para contraste
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.white, // Fondo blanco
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      // Deshabilita el botón mientras la carga está activa
      onPressed: _isLoading ? null : onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Muestra un indicador de carga si está autenticando
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_startGradientColor, _endGradientColor],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Espacio superior para imitar la distribución del diseño
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),

                    // Título de bienvenida
                    const Text(
                      '¡Bienvenido!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 48),

                    // Campo de Correo Electrónico
                    _buildTextField(
                      _emailController,
                      hintText: 'Correo Electrónico',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Campo de Contraseña
                    _buildPasswordField(_passwordController, 'Contraseña'),
                    const SizedBox(height: 24),

                    // Botón de Login (Autenticación normal)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: _primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              // Deshabilita si está cargando
                              // Lógica de Login (ej. con email/password, que no está implementada aquí)
                              // Reemplazo temporal para simular éxito:
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WelcomeScreen(),
                                ),
                              );
                            },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Center(
                      child: Text(
                        'O',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🌟🌟🌟 CONEXIÓN DEL BOTÓN DE GOOGLE 🌟🌟🌟
                    _buildGoogleSignInButton(
                      label: "Continuar con Google",
                      onPressed:
                          _handleGoogleSignIn, // Llama a la lógica de Google Sign-In
                    ),

                    const SizedBox(height: 24),

                    // Enlace para registrarse
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿Aún no tienes cuenta?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  // Deshabilita si está cargando
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                          child: const Text(
                            'Regístrate',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
