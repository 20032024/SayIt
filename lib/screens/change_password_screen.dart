import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- Pantalla 1: Ingresar Código de Confirmación ---
class ConfirmationCodeScreen extends StatefulWidget {
  const ConfirmationCodeScreen({super.key});

  @override
  State<ConfirmationCodeScreen> createState() => _ConfirmationCodeScreenState();
}

class _ConfirmationCodeScreenState extends State<ConfirmationCodeScreen> {
  // Controladores para cada campo del código
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Añadir listeners para mover el foco automáticamente
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && i < 3) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  void _validateCode() {
    final String enteredCode = _controllers.map((c) => c.text).join();
    // Código correcto hardcodeado como "1234"
    if (enteredCode == "1234") {
      // Navega a la siguiente pantalla si el código es correcto
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateNewPasswordScreen(),
        ),
      );
    } else {
      // Muestra un diálogo de error si es incorrecto
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Código Incorrecto"),
          content: const Text(
            "El código que ingresaste es incorrecto. Por favor, inténtalo de nuevo o solicita uno nuevo.",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("Reintentar"),
            ),
            TextButton(
              onPressed: () {
                // Lógica para reenviar código aquí
                Navigator.of(ctx).pop();
              },
              child: const Text("Reenviar código"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Reset password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Enter confirmation code",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "A 4-digit code was sent to\nlucasscott13@email.com",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            // --- Campos para el código ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60,
                  height: 60,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType:
                        TextInputType.number, // <-- CLAVE: Teclado numérico
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                // Lógica para reenviar el código
              },
              child: const Text(
                "Resend code",
                style: TextStyle(color: Colors.orange),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _validateCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 40), // Espacio para el teclado
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}

// --- Pantalla 2: Crear Nueva Contraseña ---
class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // --- Lógica de Validación de Contraseña ---
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa una contraseña.';
    }
    // Longitud: 8 a 20 caracteres
    if (value.length < 8 || value.length > 20) {
      return 'La contraseña debe tener entre 8 y 20 caracteres.';
    }
    // Incluir al menos un número
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Debe incluir al menos un número.';
    }
    // Incluir al menos un carácter especial (!, #, _, .)
    if (!RegExp(r'[!#_.]').hasMatch(value)) {
      return 'Debe incluir uno de los siguientes: !, #, _, .';
    }
    // No se aceptan acentos (u otros caracteres no permitidos)
    if (RegExp(r'[^A-Za-z0-9!#_.]').hasMatch(value)) {
      return 'Solo se permiten letras, números y !, #, _, .';
    }
    return null; // Válido
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Lógica para guardar la nueva contraseña
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña cambiada con éxito')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Reset password",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Create a new password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              // --- Campo de Nueva Contraseña ---
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: "Create a new password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 24),
              const Text(
                "Confirm your password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              // --- Campo de Confirmar Contraseña ---
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  hintText: "Confirm your password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden.';
                  }
                  return null;
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Espacio para el teclado
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
