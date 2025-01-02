import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taboo/extensions/theme_ext.dart';
import 'package:taboo/screens/menu_screen.dart';
import 'package:taboo/themes/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ta-Boo',
      theme: context.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: const MenuScreen(),
    );
  }
}