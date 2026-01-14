import 'package:flutter/material.dart';

class AnimatedEntry extends StatelessWidget {
  final Widget child;
  final int delay; // Tiempo de espera para efecto "cascada"

  const AnimatedEntry({
    super.key,
    required this.child,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: 1,
      ), // Va de invisible (0) a visible (1)
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic, // Curva suave profesional
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            // Se mueve 30 pixeles hacia arriba mientras aparece
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
