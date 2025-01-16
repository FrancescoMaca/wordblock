import 'package:flutter/material.dart';

class AppTheme {
  static double borderRadius = 15;
  static List<Color> backgroundGradientColors = [
    const Color(0xFFD33C9C),
    const Color(0xFF7E2CB8),
    const Color(0xFF454BB7),
  ];

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFD07BCE),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black
      ),
      backgroundColor: Color(0xFFD07BCE),
    ),    
    textTheme: TextTheme(
      titleLarge: const TextStyle(
        fontFamily: 'Anton',
        fontSize: 70,
        fontWeight: FontWeight.normal,
        color: Colors.black
      ),
      titleMedium: const TextStyle(
        fontFamily: 'Anton',
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 35,
        color: Colors.black
      ),
      bodySmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,
        color: Colors.grey.shade900
      ),
      labelSmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15,
        color: Colors.grey.shade900
      ),
    ),
    primaryColor: const Color(0xFF7D22C8),
    highlightColor: const Color(0xFFC022C8),
    primaryIconTheme: const IconThemeData(
      color: Colors.black
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Color(0xFFC23FFF)),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        side: const WidgetStatePropertyAll(
          BorderSide(
            width: 3,
          )
        ),
        foregroundColor: const WidgetStatePropertyAll(Colors.black),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
          )
        )
      )
    ),
    sliderTheme: const SliderThemeData(
      thumbColor: Color(0xFF740BC4),
      overlayColor: Color(0x80740BC4),
      activeTrackColor: Color(0xFF5C00A2),
      inactiveTrackColor: Color(0xFFEAC1E6)
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,
        color: Colors.grey.shade900
      )
    )
  );

  static ThemeData darkTheme = lightTheme;
}