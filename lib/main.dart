import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:verboten/extensions/theme_ext.dart';
import 'package:verboten/l10n/gen_l10n/app_localizations.dart';
import 'package:verboten/screens/menu_screen.dart';
import 'package:verboten/themes/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verboten',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('it'),
      ],
      theme: context.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: const MenuScreen(),
    );
  }
}