import 'package:flutter/material.dart';
import 'package:prueba_01/myPagesTema/c_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prueba_01/myPagesTema/d_color_palettes.dart';

class ThemeController extends ChangeNotifier {
  // VARIABLES DE ESTADO
  bool _isDark = false;
  MaterialColor _color = AppPalettes.all[0];
  AppStyle _style = AppStyle.standard;

  // GETTERS
  bool get isDark => _isDark;
  MaterialColor get color => _color;
  AppStyle get style => _style;

  ThemeData get theme => AppTheme.getTheme(
    color: _color,
    isDark: _isDark,
    style: _style,
  );

  /// CONSTRUCTOR
  ThemeController() {
    loadSettings();
  }

  /// =========================================================
  /// MÉTODOS DE GUARDADO (Mejorados)
  /// =========================================================

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isDark', _isDark);

    // CORRECCIÓN AQUÍ: Usamos .toARGB32()
    await prefs.setInt('colorValue', _color.toARGB32());

    await prefs.setString('styleName', _style.name);
  }

  /// =========================================================
  /// MÉTODOS DE CARGA (Mejorados)
  /// =========================================================

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _isDark = prefs.getBool('isDark') ?? false;

    // RECUPERAR COLOR
    // Buscamos en la lista qué color tiene el mismo valor que guardamos.
    // Si no lo encontramos (o es la primera vez), usamos el primero por defecto.
    int? savedColorValue = prefs.getInt('colorValue');
    if (savedColorValue != null) {
      try {
        _color = AppPalettes.all.firstWhere(
          // CORRECCIÓN AQUÍ: Comparamos usando .toARGB32()
              (element) => element.toARGB32() == savedColorValue,
          orElse: () => AppPalettes.all[0],
        );
      } catch (_) {
        _color = AppPalettes.all[0];
      }
    }

    // RECUPERAR ESTILO
    // Buscamos el estilo por nombre
    String? savedStyleName = prefs.getString('styleName');
    if (savedStyleName != null) {
      try {
        _style = AppStyle.values.firstWhere(
              (e) => e.name == savedStyleName,
          orElse: () => AppStyle.standard,
        );
      } catch (_) {
        _style = AppStyle.standard;
      }
    }

    notifyListeners();
  }

  /// =========================================================
  /// MÉTODOS DE CAMBIO (UI)
  /// =========================================================

  void toggleTheme() {
    _isDark = !_isDark;
    _saveSettings();
    notifyListeners();
  }

  void changeColor(MaterialColor newColor) {
    _color = newColor;
    _saveSettings();
    notifyListeners();
  }

  void changeStyle(AppStyle newStyle) {
    _style = newStyle;
    _saveSettings();
    notifyListeners();
  }

  /// (Opcional) Un método para resetear todo a fábrica si el usuario quiere
  void resetToDefaults() {
    _isDark = false;
    _color = AppPalettes.all[0];
    _style = AppStyle.standard;
    _saveSettings();
    notifyListeners();
  }
}