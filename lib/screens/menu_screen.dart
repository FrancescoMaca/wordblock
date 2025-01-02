import 'package:flutter/material.dart';
import 'package:taboo/audio/audio_service.dart';
import 'package:taboo/screens/game_setup_screen.dart';
import 'package:taboo/themes/theme.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AudioService.instance.stopSoundtrack();
    AudioService.instance.startSoundtrack();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AudioService.instance.pauseSoundtrack();
    } else if (state == AppLifecycleState.resumed) {
      AudioService.instance.resumeSoundtrack();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            colors: AppTheme.backgroundGradientColors
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ta-Boo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow_rounded, size: 40),
                label: Text(
                  'Play',
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                onPressed: _handlePlay,
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePlay() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GameSetupScreen())
    );
  }
}