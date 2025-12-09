import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart'; // 👈 Agregamos la importación de Firebase Core
import 'package:project_sayit/l10n/app_localizations.dart';
import 'package:project_sayit/screens/signup_screen.dart';
import 'package:project_sayit/screens/login_screen.dart'; // Importa la pantalla de login
import 'package:project_sayit/auth/auth_check.dart'; // 👈 Importamos el nuevo "vigilante"

// 1. La función main debe ser asíncrona.
void main() async {
  // 2. Asegura que los widgets de Flutter estén inicializados.
  WidgetsFlutterBinding.ensureInitialized();

  // 3. 🌟🌟🌟 INICIALIZACIÓN DE FIREBASE 🌟🌟🌟
  // Esto soluciona el error [core/no-app].
  await Firebase.initializeApp(
    // Si tu proyecto usa `flutterfire configure`, descomenta la siguiente línea:
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project SayIt Demo', // Título ajustado para consistencia
      // --- Configuración de Localización ---
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],

      theme: ThemeData(
        // Ajustamos el color principal del tema al naranja de tu diseño (0xFFFF9800)
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9800)),
        useMaterial3: true,
      ),

      home: const AuthCheckScreen(),
    );
  }
}
