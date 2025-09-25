import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Remueve la barra de AppBar para un diseño más limpio, como en el mockup.
        // Si quieres una, puedes descomentar la siguiente línea
        // title: const Text('Registro'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
            _buildTextField(_nameController, hintText: 'Luc...', isName: true),
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
              onPressed: () {
                // TODO: Lógica de registro aquí
              },
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
                  onPressed: () {
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

  // Widget para crear un campo de texto genérico
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

  // Widget para crear un campo de contraseña con el icono del ojo
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
}
