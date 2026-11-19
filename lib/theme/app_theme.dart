import 'package:flutter/material.dart';

/// Mode tema aplikasi (terang / gelap / ikut sistem).
/// Dipakai oleh tombol ganti tema di HomePage dan dibaca di main.dart.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(
  ThemeMode.system,
);

/// ── Palet warna & gradien utama aplikasi HR ──────────────────────
/// Identitas baru: indigo sebagai warna utama, dipadukan violet & teal,
/// di atas latar netral yang lembut agar terasa modern dan profesional.
class AppColors {
  AppColors._();

  static const primary = Color(0xFF4F46E5); // indigo
  static const primaryDeep = Color(0xFF3730A3);
  static const secondary = Color(0xFF0D9488); // teal
  static const accent = Color(0xFF7C3AED); // violet aksen

  static const sukses = Color(0xFF16A34A);
  static const peringatan = Color(0xFFD97706);
  static const bahaya = Color(0xFFDC2626);
  static const info = Color(0xFF2563EB);

  static const backgroundLight = Color(0xFFF5F6FB);
  static const backgroundDark = Color(0xFF0B0E16);
  static const surfaceLight = Colors.white;
  static const surfaceDark = Color(0xFF151A26);

  // Dipertahankan untuk kompatibilitas dengan kode lama.
  static const gradientAwal = Color(0xFF4338CA);
  static const gradientAkhir = Color(0xFF0D9488);

  // Gradien merek utama: indigo -> violet -> teal.
  static const gradient = LinearGradient(
    colors: [Color(0xFF4338CA), Color(0xFF6D28D9), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Bayangan lembut yang konsisten dipakai pada [SoftCard] & kartu lain
/// agar tampilan terasa "melayang" dan tidak datar.
List<BoxShadow> bayanganLembut(BuildContext context, {double opacity = 1}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return [
    BoxShadow(
      color: (isDark ? Colors.black : const Color(0xFF312E81))
          .withValues(alpha: (isDark ? 0.45 : 0.07) * opacity),
      blurRadius: 28,
      offset: const Offset(0, 14),
      spreadRadius: -8,
    ),
  ];
}

ThemeData buildLightTheme() => _buildTheme(Brightness.light);

ThemeData buildDarkTheme() => _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: brightness,
  );

  final latar = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  final kartu = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  final garis = scheme.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.6);

  RoundedRectangleBorder bentuk(double radius) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  OutlineInputBorder border(Color warna, [double lebar = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: warna, width: lebar),
      );

  final baseText = ThemeData(brightness: brightness).textTheme;
  final textTheme = baseText
      .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface)
      .copyWith(
        headlineSmall: baseText.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
        titleLarge: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        titleMedium: baseText.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: baseText.bodyMedium?.copyWith(height: 1.4),
        labelLarge: baseText.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: latar,
    textTheme: textTheme,
    splashFactory: InkSparkle.splashFactory,

    appBarTheme: AppBarTheme(
      backgroundColor: latar,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
        color: scheme.onSurface,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: kartu,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: garis),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        shape: bentuk(16),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        shape: bentuk(16),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: bentuk(12),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF1B212E) : const Color(0xFFF2F3FA),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border(Colors.transparent),
      enabledBorder: border(Colors.transparent),
      focusedBorder: border(scheme.primary, 1.6),
      errorBorder: border(scheme.error),
      focusedErrorBorder: border(scheme.error, 1.6),
      hintStyle:
          TextStyle(color: scheme.onSurfaceVariant.withValues(alpha: 0.7)),
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: bentuk(16),
      insetPadding: const EdgeInsets.all(16),
    ),

    chipTheme: ChipThemeData(
      backgroundColor:
          isDark ? const Color(0xFF1B212E) : const Color(0xFFF2F3FA),
      labelStyle:
          TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
      side: BorderSide.none,
      shape: bentuk(999),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),

    listTileTheme: ListTileThemeData(shape: bentuk(16)),
    dividerTheme: DividerThemeData(color: garis, space: 1, thickness: 1),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
  );
}
