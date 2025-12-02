import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_sayit/models/signal_description.dart';

class SignalDetailScreen extends StatelessWidget {
  final String signalId;
  final String signalName;
  final File imageFile;

  const SignalDetailScreen({
    super.key,
    required this.signalId,
    required this.signalName,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    final detail = signalDetails[signalId];

    return Scaffold(
      backgroundColor: const Color(0xFFFF9800),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              signalName,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                imageFile,
                height: 500,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              detail?["meaning"] ?? "Sin información",
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  detail?["description"] ?? "Sin descripción disponible",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
