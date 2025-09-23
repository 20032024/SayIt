import 'package:flutter/material.dart';

// --- COLORES ---
// Extraídos de tu paleta de Figma
const Color kPrimaryOrange = Color(0xFFF36D24);
const Color kSecondaryYellow = Color(0xFFF9A826);
const Color kSuccessGreen = Color(0xFF00C48C);
const Color kTextDark = Color(0xFF333333);
const Color kTextLight = Color(0xFF828282);
const Color kBackground = Color(0xFFFFFFFF);
const Color kLightGray = Color(0xFFF2F2F2);

// --- ESTILOS DE TEXTO ---
// Definimos algunos estilos básicos para reutilizar
const TextStyle kTitleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kTextDark,
);

const TextStyle kBigScoreStyle = TextStyle(
  fontSize: 96,
  fontWeight: FontWeight.bold,
  color: kSuccessGreen,
);

const TextStyle kBodyTextStyle = TextStyle(
  fontSize: 16,
  color: kTextLight,
  height: 1.5, // Espaciado entre líneas
);