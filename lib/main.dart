import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_01/myPages/a_login.dart';
import 'package:prueba_01/myPagesTema/b_theme_controller.dart';

void main() {
  runApp(
    /// 1. INYECTAMOS EL CONTROLADOR (EL CEREBRO)
    /// Usamos MultiProvider para envolver toda la app.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: const MyApp(),
    ),
  );
}/// Widget raíz de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// 2. ESCUCHAMOS LOS CAMBIOS
    /// Usamos context.watch. Si el ThemeController cambia (color, estilo, modo oscuro),
    /// esta línea avisa a Flutter que debe repintar la MaterialApp.
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',

      /// 3. ASIGNAMOS EL TEMA DINÁMICO
      /// En lugar de usar un tema fijo, usamos el que viene del controlador.
      theme: themeController.theme,

      home: const LoginPage(),
    );
  }
}