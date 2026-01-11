import 'package:flutter/material.dart';

class AppTheme {
  // Màu chủ đạo: Xanh đại dương (Sui)
  static const Color primaryColor = Color(0xFF4DA2FF);
  static const Color secondaryColor = Color(0xFF0F172A); // Màu tối (Dark blue)
  static const Color backgroundColor = Color(0xFFF8FAFC); // Màu nền xám cực nhạt (sang hơn màu trắng tinh)
  static const Color cardColor = Colors.white;

  // Cấu hình Theme chung
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        surface: cardColor,
      ),

      // Style cho thanh tiêu đề (AppBar)
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0, // Bỏ bóng đổ để nhìn phẳng (flat) và hiện đại
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: secondaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: secondaryColor),
      ),

      // Style cho các nút bấm (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bo tròn mềm mại
          ),
        ),
      ),
    );
  }
}