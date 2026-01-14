import 'package:flutter/material.dart';

/// =============================================================
/// RESPONSIVE SYSTEM - REUTILIZABLE
/// =============================================================
class Responsive {
  final double width;

  Responsive(this.width);

  /// ===============================
  /// BREAKPOINTS
  /// ===============================
  static const double mobileSmallLimit = 360;
  static const double mobileMediumLimit = 480;
  static const double tabletLimit = 600;
  static const double tabletMediumLimit = 768;
  static const double tabletLargeLimit = 900;
  static const double desktopLimit = 1024;
  static const double desktopMediumLimit = 1440;
  static const double desktopLargeLimit = 1920;

  /// ===============================
  /// FACTORY
  /// ===============================
  factory Responsive.of(BuildContext context) =>
      Responsive(MediaQuery.of(context).size.width);

  /// ===============================
  /// MOBILE
  /// ===============================
  bool get isMobileSmall => width < mobileSmallLimit;
  bool get isMobileMedium =>
      width >= mobileSmallLimit && width < mobileMediumLimit;
  bool get isMobileLarge =>
      width >= mobileMediumLimit && width < tabletLimit;
  bool get isMobile => width < tabletLimit;

  /// ===============================
  /// TABLET
  /// ===============================
  bool get isTabletSmall =>
      width >= tabletLimit && width < tabletMediumLimit;
  bool get isTabletMedium =>
      width >= tabletMediumLimit && width < tabletLargeLimit;
  bool get isTabletLarge =>
      width >= tabletLargeLimit && width < desktopLimit;
  bool get isTablet =>
      width >= tabletLimit && width < desktopLimit;

  /// ===============================
  /// DESKTOP
  /// ===============================
  bool get isDesktopSmall =>
      width >= desktopLimit && width < desktopMediumLimit;
  bool get isDesktopMedium =>
      width >= desktopMediumLimit && width < desktopLargeLimit;
  bool get isDesktopLarge => width >= desktopLargeLimit;
  bool get isDesktop => width >= desktopLimit;

  /// ===============================
  /// HELPERS ÚTILES
  /// ===============================

  /// Padding dinámico por dispositivo
  double get horizontalPadding {
    if (isDesktop) return 32;
    if (isTablet) return 24;
    return 16;
  }

  /// Máximo ancho para cards
  double get maxContentWidth {
    if (isDesktop) return 520;
    if (isTablet) return 460;
    return double.infinity;
  }

  /// Número de columnas sugeridas
  int get gridColumns {
    if (isDesktopLarge) return 4;
    if (isDesktop) return 3;
    if (isTablet) return 2;
    return 1;
  }
}
