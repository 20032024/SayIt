import 'package:flutter/material.dart';
import 'package:project_sayit/l10n/app_localizations.dart';

// Modelo simple para representar un idioma
class Language {
  final String code;
  final String name;

  Language(this.code, this.name);
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguageCode =
      'en'; // Código del idioma seleccionado por defecto

  @override
  Widget build(BuildContext context) {
    // Obtenemos las traducciones para el contexto actual
    final l10n = AppLocalizations.of(context)!;

    // Lista de idiomas soportados. Los nombres se toman de los archivos .arb
    final List<Language> supportedLanguages = [
      Language('en', l10n.english),
      Language('es', l10n.spanish),
      Language('fr', l10n.french),
      Language('de', l10n.german),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          l10n.language, // Usamos la clave 'language' del .arb
          style: const TextStyle(
            color: Color(0xFF1F2024), // Color de texto oscuro del mockup
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: supportedLanguages.length,
        itemBuilder: (context, index) {
          final language = supportedLanguages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: RadioListTile<String>(
              value: language.code,
              groupValue: _selectedLanguageCode,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguageCode = value;
                  });
                  // Aquí iría la lógica para cambiar el idioma de toda la app
                  // (usando un gestor de estado como Provider, Riverpod, etc.)
                  print('Idioma seleccionado: $value');
                }
              },
              title: Text(
                language.name,
                style: const TextStyle(fontSize: 18, color: Color(0xFF1F2024)),
              ),
              activeColor: const Color(0xFFE45F18), // Color naranja de realce
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _selectedLanguageCode == language.code
                      ? Colors.transparent
                      : Colors.grey.shade300,
                ),
              ),
              tileColor: _selectedLanguageCode == language.code
                  ? const Color(0xFFE45F18).withOpacity(0.1)
                  : Colors.white,
            ),
          );
        },
      ),
    );
  }
}
