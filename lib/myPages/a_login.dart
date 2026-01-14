import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prueba_01/myMenus/a_menu.dart';
import 'package:prueba_01/myPagesTema/a_theme_page.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  /// -------------------------------
  /// ESTADO
  /// -------------------------------
  bool isLoading = false;
  bool ocultarPassword = true;
  bool recordarDatos = false;

  final TextEditingController usuarioController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController();

  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  /// -------------------------------
  /// INIT
  /// -------------------------------
  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _logoAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );

    _logoController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  TextSpan linkSpan({
    required String text,
    required String url,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return TextSpan(
      text: text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.primary,
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w600,
      ),
      recognizer:
          TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              }
            },
    );
  }

  /// -------------------------------
  /// UI
  /// -------------------------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // 1. Permite que el fondo suba detrás del AppBar
      extendBodyBehindAppBar: true,

      // 2. AppBar transparente con botón de ajustes
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configurar Tema',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ThemePage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // CORRECCIÓN: Usamos withValues en lugar de withOpacity
              color.withValues(alpha: 0.15),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  // Espacio extra arriba para compensar el AppBar transparente
                  SizedBox(height: size.height * 0.1),

                  /// LOGO
                  ScaleTransition(
                    scale: _logoAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.cardColor,
                        boxShadow: [
                          BoxShadow(
                            // CORRECCIÓN: Usamos withValues
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logos/bird.PNG',
                          height: size.height * 0.15,
                          fit: BoxFit.cover,
                          // Icono de respaldo si falla la imagen
                          errorBuilder:
                              (c, o, s) => Icon(
                                Icons.person,
                                size: 80,
                                color: color,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  /// CARD LOGIN
                  Card(
                    elevation: 4,
                    // No definimos color ni shape aquí para que RESPETA el ThemeController
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Bienvenido',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 6),

                          Text(
                            'Ingresa tus credenciales',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: theme.hintColor),
                          ),
                          const SizedBox(height: 30),

                          /// INPUT USUARIO
                          _modernInput(
                            controller:
                                usuarioController, // Quitamos 'context' porque no se usaba
                            label: 'Usuario',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 20),

                          /// INPUT PASSWORD
                          _modernInput(
                            controller: passwordController,
                            label: 'Contraseña',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: 12),

                          /// CHECK
                          Row(
                            children: [
                              Checkbox(
                                value: recordarDatos,
                                onChanged:
                                    (v) => setState(
                                      () => recordarDatos = v!,
                                    ),
                              ),
                              const Text('Recordar usuario'),
                            ],
                          ),
                          const SizedBox(height: 30),

                          /// BOTÓN
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _login,
                              child: const Text(
                                'Ingresar',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  /// FOOTER
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodySmall,
                      children: [
                        const TextSpan(text: 'Creado por '),
                        TextSpan(
                          text: 'Insoft',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  final uri = Uri.parse(
                                    'https://www.insoft.com.pe',
                                  );
                                  launchUrl(
                                    uri,
                                    mode:
                                        LaunchMode
                                            .externalApplication,
                                  );
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// -------------------------------
  /// INPUT REUTILIZABLE
  /// -------------------------------
  Widget _modernInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? ocultarPassword : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    ocultarPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      ocultarPassword = !ocultarPassword;
                    });
                  },
                )
                : null,
      ),
    );
  }

  /// -------------------------------
  /// LOGIN LÓGICA
  /// -------------------------------
  // En a_login.dart
  /// -------------------------------
  /// LOGIN CON SIMULACIÓN DE ROLES
  /// -------------------------------
  void _login() async {
    // 1. Ocultar teclado
    FocusScope.of(context).unfocus();

    // 2. Obtener lo que escribió el usuario (limpiando espacios)
    final user = usuarioController.text.trim().toLowerCase();
    final pass = passwordController.text.trim();

    // 3. Validar campos vacíos
    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Por favor ingrese usuario y contraseña',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // 4. Activar carga
    setState(() => isLoading = true);

    // --- SIMULACIÓN DE BASE DE DATOS (2 SEGUNDOS) ---
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => isLoading = false);

    // 5. LÓGICA DE ROLES (Esto lo reemplazará tu Backend en el futuro)

    if (user == 'admin' && pass == '123') {
      // CASO 1: ES ADMINISTRADOR
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // Pasamos isAdmin: true para que MenuPage muestre el Drawer lateral
          builder: (_) => const MenuPage(isAdmin: true),
        ),
      );
    } else if (user == 'mesero' && pass == '123') {
      // CASO 2: ES MESERO / USUARIO
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // Pasamos isAdmin: false para que MenuPage muestre la barra de abajo
          builder: (_) => const MenuPage(isAdmin: false),
        ),
      );
    } else {
      // CASO 3: CREDENCIALES INCORRECTAS
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Usuario o contraseña incorrectos'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
