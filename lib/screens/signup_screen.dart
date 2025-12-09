import 'package:flutter/material.dart';
import 'package:project_sayit/auth/auth_service.dart'; // Importa tu servicio de autenticación
import 'package:project_sayit/screens/home_screen.dart'; // Importa tu pantalla principal (Home)

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // [NUEVO] Clave global para validar el formulario
  final _formKey = GlobalKey<FormState>();

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
    // [VALIDACIÓN CRÍTICA]: Verifica si el formulario es válido.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // 1. Iniciar proceso de carga
    setState(() {
      _isLoading = true;
    });

    // 2. Llama a la función del servicio que registra y guarda en Firestore
    final userCredential = await _authService.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name, // Enviamos el nombre para Firestore
    );

    if (mounted) {
      // 3. Finalizar proceso de carga
      setState(() {
        _isLoading = false;
      });

      if (userCredential != null) {
        // Éxito: Navegar a la pantalla principal
        if (mounted) {
          // Asumiendo que 'WelcomeScreen' es la pantalla principal o Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      } else {
        // Fallo: Mostrar mensaje de error
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
  // WIDGETS AUXILIARES CON VALIDACIÓN (TextFormField)
  // =========================================================

  // Widget para crear un campo de texto genérico con validación
  Widget _buildTextFormField(
    TextEditingController controller, {
    String hintText = '',
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        // Estilos para el borde de error (rojo)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        // Estilos de borde normales
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

  // Widget para crear un campo de contraseña con validación
  Widget _buildPasswordFormField(
    TextEditingController controller,
    String hintText,
    bool isVisible,
    ValueChanged<bool> onChanged, {
    // [CORRECCIÓN]: Coloca el validator dentro de llaves {}
    // Esto lo hace un parámetro NOMINADO y OPCIONAL, resolviendo el error.
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        // Estilos para el borde de error (rojo)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        // Estilos de borde normales
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
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      // Muestra el indicador de carga o el contenido
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF9800)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              // [CLAVE]: Usamos el widget Form con la clave de validación
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Título y Subtítulo
                    const Text(
                      'Registro',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Crea una cuenta para comenzar.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),

                    // ------------------------------------------------
                    // CAMPO DE NOMBRE (Validación: Solo letras y espacios)
                    // ------------------------------------------------
                    const Text('Nombre'),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      _nameController,
                      hintText: 'Luc...',
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es obligatorio.';
                        }
                        // Expresión Regular: solo letras (mayúsculas/minúsculas) y espacios.
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'El nombre solo debe contener letras y espacios.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ------------------------------------------------
                    // CAMPO DE CORREO ELECTRÓNICO (Validación: @ y número)
                    // ------------------------------------------------
                    const Text('Correo Electrónico'),
                    const SizedBox(height: 8),
                    _buildTextFormField(
                      _emailController,
                      hintText: 'nombre@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El correo es obligatorio.';
                        }
                        // 1. Debe contener '@'
                        if (!value.contains('@')) {
                          return 'Debe incluir el símbolo "@" para el dominio.';
                        }
                        // 2. Debe contener al menos un número
                        if (!RegExp(r'\d').hasMatch(value)) {
                          return 'El correo debe contener al menos un número.';
                        }
                        // 3. Validación de estructura estándar
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Formato de correo inválido o con símbolos no permitidos.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ------------------------------------------------
                    // CAMPO DE CONTRASEÑA
                    // ------------------------------------------------
                    const Text('Contraseña'),
                    const SizedBox(height: 8),
                    _buildPasswordFormField(
                      _passwordController,
                      'Crea una contraseña',
                      _isPasswordVisible,
                      (value) {
                        setState(() {
                          _isPasswordVisible = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La contraseña es obligatoria.';
                        }
                        if (value.length < 8) {
                          return 'La contraseña debe tener al menos 8 caracteres.';
                        }
                        if (!value.contains(RegExp(r'[0-9]'))) {
                          return 'La contraseña debe incluir al menos un número.'; // ESPAÑOL
                        }

                        if (!value.contains(RegExp(r'[!#\$_]'))) {
                          return 'La contraseña debe incluir un carácter especial (!, #, o _).'; // ESPAÑOL
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ------------------------------------------------
                    // CAMPO DE CONFIRMAR CONTRASEÑA (Validación: Coincidencia)
                    // ------------------------------------------------
                    const Text('Confirma tu contraseña'),
                    const SizedBox(height: 8),
                    _buildPasswordFormField(
                      _confirmPasswordController,
                      'Confirma tu contraseña',
                      _isConfirmPasswordVisible,
                      (value) {
                        setState(() {
                          _isConfirmPasswordVisible = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirma la contraseña.';
                        }
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden.';
                        }
                        return null;
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
                      onPressed: _isLoading ? null : _handleRegister,
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
            ),
    );
  }
}
