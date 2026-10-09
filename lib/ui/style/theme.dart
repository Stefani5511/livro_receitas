import 'package:flutter/material.dart';
import 'colors.dart';

abstract class AppTheme {
  static final ValueNotifier<ThemeMode> modo = ValueNotifier(ThemeMode.light);

  static ThemeData temaClaro = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.principal, brightness: Brightness.light),
    scaffoldBackgroundColor: AppColors.fundo,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.fundo, foregroundColor: AppColors.texto, centerTitle: false),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.superficie,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE9DCD2))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE9DCD2))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.principal, width: 1.5)),
    ),
    cardTheme: CardThemeData(color: AppColors.superficie, elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
  );

  static ThemeData temaEscuro = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.principal, brightness: Brightness.dark),
    scaffoldBackgroundColor: const Color(0xFF211A17),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF211A17), foregroundColor: Colors.white, centerTitle: false),
    cardTheme: CardThemeData(color: const Color(0xFF332722), elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
  );
}
