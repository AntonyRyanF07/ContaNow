import 'package:flutter/material.dart';

class TemaAplicativo {
  static const roxo = Color(0xFF6036BD);
  static const fundo = Color(0xFFF7F5FA);
  static const verde = Color(0xFF248457);
  static const vermelho = Color(0xFFC44C45);

  static ThemeData get tema {
    final base = ThemeData(
        useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: roxo));
    return base.copyWith(
      scaffoldBackgroundColor: fundo,
      appBarTheme:
          const AppBarTheme(backgroundColor: fundo, centerTitle: false),
      cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
