import 'package:flutter/material.dart';
import 'lesson_screen.dart';
import 'lesson_summary_screen.dart';
import '../app_styles.dart'; 

Future<void> showEvaluationDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Evaluación', style: kTitleStyle),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: kTextLight),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('La precisión de tu pronunciación es de:', style: kBodyTextStyle),
              const SizedBox(height: 8),
              const Text(
                '97%',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: kSuccessGreen,
                ),
              ),
              const SizedBox(height: 16),
              const Text('¿Te gustaría volver a repetir esta palabra?', style: kBodyTextStyle),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back, color: kTextDark),
                label: const Text('REPETIR', style: TextStyle(color: kTextDark)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSecondaryYellow,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                // --- INICIO DE LA MODIFICACIÓN ---
                onPressed: () {
                  // 1. Primero, cierra el diálogo actual.
                  Navigator.of(context).pop();

                  // 2. Luego, navega a la pantalla de resumen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LessonSummaryScreen()),
                  );
                },
                // --- FIN DE LA MODIFICACIÓN ---
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryOrange,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('SIGUIENTE PALABRA', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}