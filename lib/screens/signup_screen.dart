import 'package:flutter/material.dart';
import 'package:project_sayit/auth/auth_service.dart'; // Importa tu servicio de autenticación
import 'package:project_sayit/screens/home_screen.dart'; // Importa tu pantalla principal (Home)

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // Se cambia el nombre del State para mantener la consistencia
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Instancia del servicio de autenticación
  final AuthService _authService = AuthService();

  // Define el color principal de la aplicación, que parece ser naranja.
  final Color _primaryColor = const Color(0xFFFF9800);

  // Controladores para los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Controla la visibilidad de la contraseña
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false; // Estado para el indicador de carga

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // =========================================================
  // LOGICA DE REGISTRO CON FIREBASE Y FIRESTORE
  // =========================================================
  Future<void> _handleRegister() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    // 1. Validación de campos vacíos
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    // 2. Validación de contraseñas coincidentes
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      return;
    }

    // 3. Iniciar proceso de carga
    setState(() {
      _isLoading = true;
    });

    // 4. Llama a la función del servicio que registra y guarda en Firestore
    final userCredential = await _authService.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name, // Enviamos el nombre para Firestore
    );

    if (mounted) {
      // 5. Finalizar proceso de carga
      setState(() {
        _isLoading = false;
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
        // Fallo: Mostrar mensaje de error (ejemplo)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Fallo en el registro. El correo podría estar en uso o la contraseña es débil.',
            ),
          ),
        );
      }
    }
  }

  // =========================================================
  // WIDGETS AUXILIARES
  // =========================================================

  // Widget para crear un campo de texto genérico (Tus estilos originales)
  Widget _buildTextField(
    TextEditingController controller, {
    String hintText = '',
    TextInputType keyboardType = TextInputType.text,
    bool isName = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  // Widget para crear un campo de contraseña con el icono del ojo (Tus estilos originales)
  // Ahora toma el estado `isVisible` y el setter `onChanged` directamente
  Widget _buildPasswordField(
    TextEditingController controller,
    String hintText,
    bool isVisible,
    ValueChanged<bool> onChanged,
  ) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            onChanged(!isVisible);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Remueve la barra de AppBar para un diseño más limpio, como en el mockup.
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Muestra el indicador de carga o el contenido
      body: _isLoading
          ? const Center(
              // Usamos el color primario para el indicador de carga
              child: CircularProgressIndicator(color: Color(0xFFFF9800)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Título principal
                  const Text(
                    'Registro',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Subtítulo
                  const Text(
                    'Crea una cuenta para comenzar.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Campo de Nombre
                  const Text('Nombre'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _nameController,
                    hintText: 'Luc...',
                    isName: true,
                  ),
                  const SizedBox(height: 16),

                  // Campo de Correo Electrónico
                  const Text('Correo Electrónico'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _emailController,
                    hintText: 'nombre@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Campo de Contraseña
                  const Text('Contraseña'),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    _passwordController,
                    'Crea una contraseña',
                    _isPasswordVisible,
                    (value) {
                      setState(() {
                        _isPasswordVisible = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo de Confirmar Contraseña
                  const Text('Confirma tu contraseña'),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    _confirmPasswordController,
                    'Confirma tu contraseña',
                    _isConfirmPasswordVisible,
                    (value) {
                      setState(() {
                        _isConfirmPasswordVisible = value;
                      });
                    },
                  ),
                  const SizedBox(height: 40),

                  // Botón de Registrarse
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
                        : _handleRegister, // Conectado a la lógica de registro
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Enlace para volver a Iniciar Sesión
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿Ya tienes una cuenta?"),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                        child: Text(
                          'Inicia Sesión',
                          style: TextStyle(color: _primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
