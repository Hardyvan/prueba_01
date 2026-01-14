import 'package:flutter/material.dart';

class AppPalettes {

  /// ------------------------------------------------------------
  /// 1. FUNCIÓN MÁGICA (Generador de MaterialColor)
  /// Esto permite crear una paleta completa de 10 tonos a partir de 1 solo color.
  /// ------------------------------------------------------------
  static MaterialColor _createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.r.toInt(), g = color.g.toInt(), b = color.b.toInt(); // Updated for Flutter 3.22+

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  /// ------------------------------------------------------------
  /// 2. COLORES PERSONALIZADOS (Tu Marca)
  /// Aquí defines el color exacto de tu logo o marca
  /// ------------------------------------------------------------

  // Ejemplo: Un Azul "Insoft" más profesional y oscuro
  static final MaterialColor insoftBlue = _createMaterialColor(const Color(0xFF0056D2));

  // Ejemplo: Un color "Tomate" vibrante para comida
  static final MaterialColor foodOrange = _createMaterialColor(const Color(0xFFFF6B00));

  // Ejemplo: Un color "Carbón" moderno para interfaces serias
  static final MaterialColor carbon = _createMaterialColor(const Color(0xFF2C3E50));


  /// ------------------------------------------------------------
  /// 3. LISTA DE SELECCIÓN
  /// ------------------------------------------------------------
  static final List<MaterialColor> all = [
    // Tus personalizados primero
    insoftBlue,
    foodOrange,

    // Los estándar de Flutter (pero los más bonitos)
    Colors.indigo,
    Colors.teal,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.pink,
    carbon, // Nuestro negro azulado personalizado
    Colors.blueGrey,
  ];

  /// 4. Helper para obtener nombres (Opcional, para mostrar en UI)
  static String getName(MaterialColor color) {
    if (color == insoftBlue) return "Insoft";
    if (color == foodOrange) return "Gourmet";
    if (color == carbon) return "Elegant";
    if (color == Colors.indigo) return "Indigo";
    // ... etc
    return "Color";
  }
}