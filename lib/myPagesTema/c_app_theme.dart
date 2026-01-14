import 'package:flutter/material.dart';

/// Definimos los 4 estilos visuales
enum AppStyle {
  standard, // Tu estilo actual
  modern,   // Bordes muy redondeados (M3)
  elegant,  // Bordes cuadrados, sofisticado
  tech      // Bordes biselados o finos
}

class AppTheme {

  static ThemeData getTheme({
    required MaterialColor color,
    required bool isDark,
    required AppStyle style,
  }) {
    // 1. Base de luminosidad
    final brightness = isDark ? Brightness.dark : Brightness.light;

    // 2. Generamos la paleta completa basada en tu color semilla
    final colorScheme = ColorScheme.fromSeed(
        seedColor: color,
        brightness: brightness
    );

    // 3. Configuración base
    var theme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      // 'primarySwatch' ya no es necesario si usas colorScheme.fromSeed
      scaffoldBackgroundColor: isDark ? null : colorScheme.surface,
    );

    // 4. APLICAMOS LAS VARIANTES DE ESTILO
    switch (style) {

    // --- ESTILO STANDARD (Balanceado) ---
      case AppStyle.standard:
        return theme.copyWith(
          appBarTheme: AppBarTheme(
            backgroundColor: isDark ? null : color, // Null usa el defecto dark
            foregroundColor: isDark ? null : Colors.white,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color.withValues(alpha: 0.5)),
            ),
          ),
        );

    // --- ESTILO MODERN (Cápsula / Soft UI) ---
      case AppStyle.modern:
        return theme.copyWith(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: const StadiumBorder(), // Botones totalmente redondos
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            // Usamos surfaceContainerHighest para un gris que combine con el color base
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: color, width: 2),
            ),
          ),
        );

    // --- ESTILO ELEGANT (Cuadrado / Serio) ---
      case AppStyle.elegant:
        return theme.copyWith(
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 4, // Sombra suave al scrollear
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              elevation: 0,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
          ),
          cardTheme: CardTheme(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            elevation: 2,
            color: colorScheme.surfaceContainerLow,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: false,
            border: UnderlineInputBorder(),
          ),
        );

    // --- ESTILO TECH (Futurista / Gamer) ---
      case AppStyle.tech:
        return theme.copyWith(
          // Fondo un poco más oscuro en dark mode para efecto "Matrix/Hacker"
          scaffoldBackgroundColor: isDark ? const Color(0xFF0F172A) : Colors.grey[100],
          appBarTheme: AppBarTheme(
            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.grey[100],
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontFamily: 'Courier', // Fuente monoespaciada (opcional)
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: colorScheme.primary,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              // Bordes cortados (Beveled)
              shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: isDark ? Colors.black : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4), // Bordes casi cuadrados
              borderSide: BorderSide(color: colorScheme.primary),
            ),
          ),
        );
    }
  }
}