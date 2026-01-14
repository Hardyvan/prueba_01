import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_01/myPagesTema/b_theme_controller.dart';
import 'package:prueba_01/myPagesTema/c_app_theme.dart'; // Importante para AppStyle
import 'package:prueba_01/myPagesTema/d_color_palettes.dart';
import 'package:prueba_01/myPagesTema/e_responsive.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos watch aquí para que toda la página reaccione a los cambios
    // y la "Vista Previa" se actualice en tiempo real.
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar Experiencia'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 1. TARJETA DE VISTA PREVIA (NUEVO 🔥)
            // Esto muestra al usuario cómo se ven sus cambios al instante
            /*_PreviewSection(theme: theme, colors: colors),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),*/

            // 2. SWITCH MODO OSCURO
            const _ThemeSwitchTile(),

            const SizedBox(height: 25),

            // 3. PALETA DE COLORES
            Text(
              'Color Corporativo',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Selecciona el color principal de tu marca',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 15),
            const _ThemeColorPicker(),

            const SizedBox(height: 25),

            // 4. ESTILO VISUAL (DESCOMENTADO Y MEJORADO)
            Text(
              'Estilo de Componentes',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Define la forma de botones y entradas',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 15),
            const _ThemeStyleSelector(),

            const SizedBox(height: 40), // Espacio final
          ],
        ),
      ),
    );
  }
}

/// =============================================================
/// 1. SECCIÓN DE VISTA PREVIA (EL "WOW" FACTOR)
/// =============================================================

/*class _PreviewSection extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colors;

  const _PreviewSection({required this.theme, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Sin sombra para que se integre mejor
      color: colors.surfaceContainerHighest.withValues(alpha: 0.3), // Fondo sutil
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Vista Previa", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 15),

            // Fila de Ejemplo: Botón y Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Botón"),
                ),
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Icon(Icons.send),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Input de Ejemplo
            TextField(
              enabled: false, // Lo deshabilitamos para que sea solo visual
              decoration: InputDecoration(
                labelText: 'Input de Ejemplo',
                prefixIcon: Icon(Icons.person, color: colors.primary),
                hintText: 'Escribe algo...',
                filled: true,
                // TRUCO: Si es dark, usamos un color mas claro que el fondo. Si es light, blanco.
                fillColor: theme.brightness == Brightness.dark
                    ? colors.surfaceContainerHigh // Gris claro en modo oscuro
                    : Colors.white,               // Blanco en modo claro
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

/// =============================================================
/// 2. SWITCH OPTIMIZADO
/// =============================================================
class _ThemeSwitchTile extends StatelessWidget {
  const _ThemeSwitchTile();

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<ThemeController, bool>((c) => c.isDark);

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Modo Oscuro', style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(isDark ? 'Descansa tu vista con tonos oscuros' : 'Interfaz clara y luminosa'),
      value: isDark,
      activeColor: Theme.of(context).colorScheme.primary,
      onChanged: (_) {
        context.read<ThemeController>().toggleTheme();
      },
    );
  }
}

/// =============================================================
/// 3. SELECTOR DE COLORES (CON NOMBRE)
/// =============================================================
class _ThemeColorPicker extends StatelessWidget {
  const _ThemeColorPicker();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Consumer<ThemeController>(
      builder: (context, controller, _) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          children: AppPalettes.all.map((color) {
            final isSelected = controller.color.value == color.value; // Compara por valor

            return GestureDetector(
              onTap: () => controller.changeColor(color),
              child: AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: responsive.isMobile ? 45 : 55,
                  height: responsive.isMobile ? 45 : 55,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.transparent,
                      width: isSelected ? 3 : 0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 22)
                      : null,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// =============================================================
/// 4. SELECTOR DE ESTILOS (CHIPS MEJORADOS)
/// =============================================================
class _ThemeStyleSelector extends StatelessWidget {
  const _ThemeStyleSelector();

  // AYUDA VISUAL: Asignamos un icono a cada estilo para que el cerebro lo procese rápido
  IconData _getStyleIcon(AppStyle style) {
    switch (style) {
      case AppStyle.standard: return Icons.check_box_outline_blank_rounded; // Balanceado
      case AppStyle.modern:   return Icons.circle_outlined;                 // Redondo
      case AppStyle.elegant:  return Icons.square_outlined;                 // Cuadrado
      case AppStyle.tech:     return Icons.code;                            // Técnico/Biselado
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<ThemeController>();
    final colorScheme = theme.colorScheme;

    return Center(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: AppStyle.values.map((style) {
          final isSelected = controller.style == style;
          final styleIcon = _getStyleIcon(style);

          return ChoiceChip(
            // --- CONTENIDO ---
            avatar: Icon(
              styleIcon,
              size: 18,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
            ),
            label: Text(
              style.name.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),

            // --- LÓGICA ---
            selected: isSelected,
            onSelected: (bool selected) {
              if (selected) controller.changeStyle(style);
            },

            // --- DISEÑO ---
            showCheckmark: false, // Quitamos el check default, usamos nuestro icono/color
            elevation: isSelected ? 4 : 0, // Sombra suave al seleccionar
            pressElevation: 2,

            // Colores
            selectedColor: colorScheme.primary,
            backgroundColor: theme.brightness == Brightness.dark
                ? colorScheme.surfaceContainerHigh
                : Colors.grey.shade100,

            // Bordes y Forma
            side: BorderSide.none, // Sin borde, más limpio
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Forma de pastilla perfecta
            ),

            // Texto
            labelStyle: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),

            // Padding interno para que respire
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          );
        }).toList(),
      ),
    );
  }
}
