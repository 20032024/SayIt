import 'package:flutter/material.dart';
import 'package:project_sayit/screens/change_password_screen.dart';
import 'package:project_sayit/screens/language_screen.dart';
import 'package:project_sayit/screens/login_screen.dart';
import 'package:project_sayit/screens/privacy_security_screen.dart';
import 'package:project_sayit/screens/about_us_screen.dart';
import 'custom_bottom_nav.dart';
import 'package:project_sayit/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Necesitas el tipo User

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService(); // Instancia del servicio
  String _displayName = 'User Name';
  String _userIdentifier = '@alias';
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Llama a la función para cargar los datos
  }

  void _loadUserInfo() {
    final User? user = _authService.getCurrentUser();

    if (user != null) {
      // 1. Obtener el Nombre Principal
      // Prioriza displayName (si viene de Google) o usa la parte del correo
      String name = user.displayName ?? user.email ?? 'No Name';

      // Si el nombre principal es el correo (común si no se definió uno al registrar)
      if (name.contains('@') && name != user.email) {
        // Si es un correo, solo tomamos la parte antes del '@' como nombre
        name = name.split('@')[0];
      }

      // 2. Obtener el Identificador/Alias (Usaremos el correo para Google)
      String identifier =
          user.email ?? user.uid; // Si el email es null, usa el UID

      setState(() {
        _displayName = name;
        _userIdentifier = identifier;
      });
    }
  }

  // --- FUNCIÓN NUEVA PARA MOSTRAR LA ALERTA ---
  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Profile Edit"), // Título de la ventana
          content: const Text("Edit bottom works"), // Mensaje
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                // Cierra la ventana emergente al presionar OK
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // preguntar si quiere cerrar la sesión antes de proceder.
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                // Simplemente cierra el diálogo.
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red), // Estilo para la acción
              ),
              onPressed: () {
                // Cierra todas las pantallas y navega a la pantalla de Login.
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) =>
                      false, // Elimina todas las rutas anteriores
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ... (Stack con el CircleAvatar)
                // ...
                const SizedBox(height: 16),
                // [USAR VARIABLE DE ESTADO 1: Nombre Principal]
                Text(
                  _displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // [USAR VARIABLE DE ESTADO 2: Email/Identificador]
                Text(
                  _userIdentifier,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 48),
                _buildSettingsList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }

  Widget _buildSettingsList() {
    return Column(
      children: [
        _buildSettingsItem(
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConfirmationCodeScreen(),
              ),
            );
          },
        ),
        _buildSettingsItem(
          icon: Icons.language,
          title: 'Language',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LanguageScreen()),
            );
          },
        ),
        _buildSettingsItem(
          icon: Icons.shield_outlined,
          title: 'Privacy & Security',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PrivacySecurityScreen(),
              ),
            );
          },
        ),

        _buildSettingsItem(
          icon: Icons.info_outline, // Icono de información
          title: 'About Us',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutUsScreen()),
            );
          },
        ),

        const Divider(height: 1, color: Color(0xFFF1F1F1)),
        _buildNotificationItem(),
        const Divider(height: 1, color: Color(0xFFF1F1F1)),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
          onTap: _showLogoutConfirmationDialog,
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: Icon(icon, color: const Color(0xFF374151)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildNotificationItem() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: const Icon(
        Icons.notifications_outlined,
        color: Color(0xFF374151),
      ),
      title: const Text(
        'Notifications',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Switch(
        value: notificationsEnabled,
        onChanged: (bool value) {
          setState(() {
            notificationsEnabled = value;
          });
        },
        activeColor: Colors.white,
        activeTrackColor: const Color.fromARGB(170, 255, 112, 2),
      ),
    );
  }
}
