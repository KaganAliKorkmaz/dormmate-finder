import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1a237e);
  static const Color secondary = Color(0xFFEC407A);
  static const Color background = Color(0xFF1a237e);
  static const Color white = Colors.white;
  static const Color green = Colors.green;
  static const Color red = Colors.red;
  static const Color grey = Colors.grey;
  
  static Color whiteWithOpacity(double opacity) => Colors.white.withOpacity(opacity);
  static Color greyWithOpacity(double opacity) => Colors.grey.withOpacity(opacity);
}

