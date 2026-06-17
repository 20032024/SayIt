import 'package:flutter/material.dart';
import 'package:project_sayit/screens/signup_screen.dart';
import 'package:project_sayit/screens/home_screen.dart'; // Asegúrate de que WelcomeScreen esté disponible o cámbialo a HomeScreen
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
  final Color _startGradientColor = const Color(0xFFFFCC80);
  final Color _endGradientColor = const Color(0xFFFF9800);
  final Color _primaryColor = const Color(0xFFFF9800);

  // Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // FUNCIONES DE VALIDACIÓN (TRADUCIDAS AL ESPAÑOL)
  // =========================================================

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu correo electrónico.'; // ESPAÑOL
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, ingresa un formato de correo válido.'; // ESPAÑOL
    }
    if (!value.toLowerCase().endsWith('@gmail.com')) {
      return 'Solo se permiten cuentas de @gmail.com.'; // ESPAÑOL
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu contraseña.'; // ESPAÑOL
    }
    if (value.length > 20) {
      return 'La contraseña debe tener un máximo de 20 caracteres.'; // ESPAÑOL
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe incluir al menos un número.'; // ESPAÑOL
    }
    if (!value.contains(RegExp(r'[!#\$_]'))) {
      return 'La contraseña debe incluir un carácter especial (!, #, o _).'; // ESPAÑOL
    }
    return null;
  }

  // =========================================================
  // LOGICA DE AUTENTICACIÓN
  // =========================================================

  // [NUEVA FUNCIÓN]: Maneja el login con email y contraseña
  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    final userCredential = await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (userCredential != null) {
        // Éxito: Contraseña y usuario correctos
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } else {
        // Fallo: Contraseña incorrecta o usuario no encontrado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Fallo en el inicio de sesión. Verifica tu correo y contraseña.', // ESPAÑOL
            ),
          ),
        );
      }
    }
  }

  // Lógica de Google Sign-In (TRADUCIDA AL ESPAÑOL)
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final UserCredential? userCredential = await _authService
        .signInWithGoogle();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (userCredential != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inicio de sesión con Google cancelado o fallido.'),
            ), // ESPAÑOL
          );
        }
      }
    }
  }

  // WIDGETS AUXILIARES (SE DEJAN EN INGLÉS, SOLO CAMBIÉ LA LLAMADA EN BUILD)
  Widget _buildTextField(
    TextEditingController controller, {
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          validator: validator,
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
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String labelText,
    String hintText,
    String? Function(String?)? validator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          obscureText: !_isPasswordVisible,
          validator: validator,
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

  Widget _buildGoogleSignInButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/2048px-Google_%22G%22_logo.svg.png',
        height: 24.0,
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),

                      const Text(
                        '¡Bienvenido!', // TRADUCIDO AL ESPAÑOL
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
                        labelText: 'Correo Electrónico', // TRADUCIDO
                        hintText: 'ejemplo@gmail.com', // TRADUCIDO
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),

                      // Campo de Contraseña
                      _buildPasswordField(
                        _passwordController,
                        'Contraseña', // TRADUCIDO
                        'Ingresa tu contraseña', // TRADUCIDO
                        _validatePassword,
                      ),
                      const SizedBox(height: 24),

                      // Botón de Login
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: _primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleEmailLogin,
                        child: const Text(
                          'Iniciar Sesión', // TRADUCIDO
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
                        label: "Continuar con Google", // TRADUCIDO
                        onPressed: _handleGoogleSignIn,
                      ),

                      const SizedBox(height: 24),

                      // Enlace para registrarse
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿Aún no tienes cuenta?', // TRADUCIDO
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
                              'Regístrate', // TRADUCIDO
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
