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
  // 1. CLAVE GLOBAL DEL FORMULARIO
  final _formKey = GlobalKey<FormState>();

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
  // FUNCIONES DE VALIDACIÓN
  // =========================================================

  // Validaciones de Email: formato válido y debe terminar en @gmail.com
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please, enter your email address.';
    }

    // Regex para formato de correo electrónico básico (ej. user@dominio.com)
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email format';
    }

    // Validación específica de que termine en @gmail.com (según tu requisito)
    if (!value.toLowerCase().endsWith('@gmail.com')) {
      return 'Only @gmail.com accounts are allowed.';
    }
    return null;
  }

  // Validaciones de Contraseña: máx 20, número y caracter especial (!, #, $, _)
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }

    // Máximo de 20 caracteres
    if (value.length > 20) {
      return 'The password must be a maximum of 20 characters.';
    }

    // Debe incluir un número
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'The password must include at least one number..';
    }

    // Debe incluir un caracter especial (!, #, $, o _)
    // Usamos r'[!#\$_]' para buscar cualquiera de esos caracteres
    if (!value.contains(RegExp(r'[!#\$_]'))) {
      return 'The password must include a special character (!, #, or _).';
    }

    return null;
  }

  // =========================================================
  // WIDGETS AUXILIARES
  // =========================================================

  // Widget para crear un campo de texto genérico
  Widget _buildTextField(
    TextEditingController controller, {
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?)? validator, // <-- Se añade el validador
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Alinea la etiqueta a la izquierda
      children: [
        // LA ETIQUETA (LABEL)
        Text(
          labelText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator, // <-- Se aplica la función de validación
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            filled: true,
            fillColor: Colors.black.withOpacity(0.15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            // Estilo para el texto de error (se usa para que el error sea visible)
            errorStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Widget para crear un campo de contraseña
  Widget _buildPasswordField(
    TextEditingController controller,
    String labelText, // <-- Nuevo argumento para la etiqueta
    String hintText,
    String? Function(String?)? validator, // <-- Se añade el validador
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Alinea la etiqueta a la izquierda
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8), // Espacio entre la etiqueta y el campo

        TextFormField(
          controller: controller,
          obscureText: !_isPasswordVisible,
          validator: validator, // <-- Se aplica la función de validación
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            filled: true,
            fillColor: Colors.black.withOpacity(0.15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
        ),
      ],
    );
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
            const SnackBar(content: Text('Google Sign-In canceled or failed.')),
          );
        }
      }
    }
  }

  // WIDGET PARA EL BOTÓN DE GOOGLE
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
                // EL WIDGET FORM ENVUELVE LOS CAMPOS
                child: Form(
                  key: _formKey, // <-- Asigna la clave del formulario
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),

                      const Text(
                        'Welcome!',
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
                        labelText: 'Email Address', // <-- Etiqueta
                        hintText: 'example@gmail.com', // <-- Hint
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail, // <-- Aplica la validación
                      ),
                      const SizedBox(height: 16),

                      // Campo de Contraseña
                      _buildPasswordField(
                        _passwordController,
                        'Password',
                        'Enter your password', // <-- Hint
                        _validatePassword, // <-- Aplica la validación
                      ),
                      const SizedBox(height: 24),

                      // Botón de Login (Ahora solo realiza la validación local)
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
                                // Ejecuta la validación al presionar el botón
                                if (_formKey.currentState!.validate()) {
                                  // Si la validación local pasa, puedes proceder con Firebase más tarde.
                                  // Por ahora, solo navegamos.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Local validation successful. Ready for Firebase login.',
                                      ),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WelcomeScreen(),
                                    ),
                                  );
                                }
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

                      // CONEXIÓN DEL BOTÓN DE GOOGLE
                      _buildGoogleSignInButton(
                        label: "Continue with Google",
                        onPressed: _handleGoogleSignIn,
                      ),

                      const SizedBox(height: 24),

                      // Enlace para registrarse
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Do not have an account yet?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ),
                                    );
                                  },
                            child: const Text(
                              'Sign Up',
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
            ),
    );
  }
}
