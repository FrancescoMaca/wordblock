import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taboo/audio/audio_service.dart';
import 'package:taboo/components/scroll_physics.dart';
import 'package:taboo/extensions/theme_ext.dart';
import 'package:taboo/l10n/gen_l10n/app_localizations.dart';
import 'package:taboo/models/game_mode.dart';
import 'package:taboo/models/game_settings.dart';
import 'package:taboo/screens/game_screen.dart';
import 'package:taboo/screens/menu_screen.dart';

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  final List<TextEditingController> _teamControllers = List.generate(4, (_) => TextEditingController());
  final List<String?> _teamErrors = List.generate(4, (_) => null);
  final _pageController = PageController();
  int _selectedTime = 60;
  int _selectedSkips = 3;
  int _numberOfTeams = 2;
  int _targetPoints = 20;
  int _numberOfRounds = 3;
  GameMode _selectedMode = GameMode.quick;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    for (var controller in _teamControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_pageController.page! >= 3.0 && _pageController.page! < 4.0) {
      double progress = (_pageController.page! - 3.0);
      
      if (progress > 0.1) {
        int intervalMs = (300 * (1 - progress)).round();
        intervalMs = intervalMs.clamp(50, 300);
        
        if (progress > 0.7) {
          HapticFeedback.heavyImpact();
        } else if (progress > 0.3) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.lightImpact();
        }
        
        if (progress > 0.9) {
          _pageController.removeListener(_onScroll);

          HapticFeedback.heavyImpact();
          
          _pageController.animateToPage(
            4,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          ).then(_startGameOrHandleErrors).catchError((e) => print(e));
        }
      }
    }
  }

  bool _validateTeamNames() {
    bool isValid = true;
    setState(() {
      for (int i = 0; i < _numberOfTeams; i++) {
        if (_teamControllers[i].text.trim().isEmpty) {
          _teamErrors[i] = AppLocalizations.of(context).error_team_name(i + 1);
          isValid = false;
        } else {
          _teamErrors[i] = null;
        }
      }
    });
    return isValid;
  }

  void _startGameOrHandleErrors(_) async {
    if (_validateTeamNames()) {
      await AudioService.instance.play('success_setup.mp3');

      final settings = GameSettings(
        teamNames: _teamControllers
            .take(_numberOfTeams)
            .map((controller) => controller.text.trim())
            .toList(),
        timeLimit: _selectedTime,
        skipsAllowed: _selectedSkips,
        numberOfTurns: _numberOfRounds,
        maxPoints: _targetPoints,
        mode: _selectedMode,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TabooGameScreen(settings: settings),
        ),
      );
    } else {
      await AudioService.instance.play('error_setup.mp3');
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      ).then((_) {
        _pageController.addListener(_onScroll);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).title_setup_game, style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton.outlined(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenuScreen(),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app_rounded, size: 25,)
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const StiffScrollPhysics(
          parent: ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
        ),
        children: [
          _buildPage(
            child: _buildTeamNameSection()
          ),
          _buildPage(
            child: _buildGameModeSection()
          ),
          _buildPage(
            child: _buildGameSettingsSection()
          ),
          _buildPage(
            child: _buildSwipeToStart(),
            hideSwipeHint: true,
            centerContent: true
          ),
          _buildPage(
            child: null,
            hideSwipeHint: true,
            centerContent: true
          )
        ]
      )
    );
  }

  Widget _buildGameSettingsSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -60,
          left: 0,
          child: Text(
            AppLocalizations.of(context).title_settings,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color.fromARGB(66, 92, 0, 162)
            ),
          )
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Slider(
              value: _selectedTime.toDouble(),
              min: 30,
              max: 120,
              divisions: 6,
              onChanged: (value) {
                HapticFeedback.mediumImpact();
                setState(() {
                  _selectedTime = value.round();
                });
              },
            ),
            Text(
              AppLocalizations.of(context).label_round_time(_selectedTime),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Slider(
              value: _selectedSkips.toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              onChanged: (value) {
                HapticFeedback.mediumImpact();
                setState(() {
                  _selectedSkips = value.round();
                });
              },
            ),
            Text(
              AppLocalizations.of(context).label_skips_allowed(_selectedSkips),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (_selectedMode == GameMode.targeted)
              const SizedBox(height: 20),
            if (_selectedMode == GameMode.targeted)
              Slider(
                value: _targetPoints.toDouble(),
                min: 5,
                max: 40,
                divisions: 7,
                onChanged: (value) {
                  HapticFeedback.mediumImpact();
                  setState(() {
                    _targetPoints = value.round();
                  });
                },
              ),
            if (_selectedMode == GameMode.targeted)
              Text(
                AppLocalizations.of(context).label_points_needed(_targetPoints),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            if (_selectedMode == GameMode.quick)
              const SizedBox(height: 20),
            if (_selectedMode == GameMode.quick)
              Slider(
                value: _numberOfRounds.toDouble(),
                min: 2,
                max: 30,
                divisions: 14,
                onChanged: (value) {
                  HapticFeedback.mediumImpact();
                  setState(() {
                    _numberOfRounds = value.round();
                  });
                },
              ),
            if (_selectedMode == GameMode.quick)
              Text(
                AppLocalizations.of(context).label_number_of_turns(_numberOfRounds),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPage({required Widget? child, bool hideSwipeHint = false, bool centerContent = false}) {

    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight,
        bottom: 20,
        left: 24,
        right: 24,
      ),
      decoration: child == null ? BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [ 0, 0.4 ],
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Colors.greenAccent,
          ]
        )
      ) : null,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!hideSwipeHint || centerContent) const SizedBox(),
            if (child != null) child
            else Text(AppLocalizations.of(context).title_have_fun, style: Theme.of(context).textTheme.titleLarge),
            if (!hideSwipeHint) _buildSwipeDownTag()
          ],
        ),
      ),
    );
  }

  Widget _buildTeamNameSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -60,
          left: 0,
          child: Text(
            AppLocalizations.of(context).title_teams,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0x425C00A2)
            ),
          )
        ),
        Column(
          children: [
            const SizedBox(height: 17),
            for (int i = 0; i < _numberOfTeams; i++) ...[
              TextFormField(
                controller: _teamControllers[i],
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                autocorrect: false,
                keyboardType: TextInputType.name,
                keyboardAppearance: context.isDarkMode ? Brightness.dark : Brightness.light,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  labelText: 'Team ${i + 1}',
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade900, width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(15))
                  ),
                  errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.red.shade900
                  )
                ),
                forceErrorText: _teamErrors[i],
                onChanged: (value) => setState(() => _teamErrors[i] = null),
              ),
              const SizedBox(height: 20),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_numberOfTeams > 2)
                  TextButton.icon(
                    onPressed: () => setState(() => _numberOfTeams--),
                    icon: const Icon(Icons.remove_circle_outline),
                    label: Text(AppLocalizations.of(context).label_remove_team),
                  ),
                if (_numberOfTeams < 4)
                  TextButton.icon(
                    onPressed: () => setState(() => _numberOfTeams++),
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(AppLocalizations.of(context).label_add_team),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGameModeSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -60,
          right: 0,
          child: Text(
            AppLocalizations.of(context).title_modes,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0x425C00A2)
            ),
          )
        ),
        Column(
          children: GameMode.values.map<Widget>((value) =>
            Column(
              children: [
                _buildGameModeRow(title: value.getLocalizedText(context)),
                const SizedBox(height: 15)
              ],
            )
          ).toList(),
        )
      ],
    );
  }

  Widget _buildSwipeToStart() {

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Theme.of(context).highlightColor.withOpacity(0.2),
                Theme.of(context).primaryColor.withOpacity(0.3),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).swipe, 
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).primaryColor
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(AppLocalizations.of(context).down, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).primaryColor
                )),
                Text(AppLocalizations.of(context).to, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).highlightColor
                )),
              ],
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context).start, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).highlightColor
                )),
                Icon(
                  Icons.arrow_downward_rounded,
                  size: 60,
                  color: Theme.of(context).highlightColor,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwipeDownTag() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.arrow_downward_rounded, size: 20),
        const Icon(Icons.arrow_downward_rounded, size: 20),
        const SizedBox(width: 10),
        Text(
          AppLocalizations.of(context).label_swipe_down,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(width: 10),
        const Icon(Icons.arrow_downward_rounded, size: 20),
        const Icon(Icons.arrow_downward_rounded, size: 20),
      ]
    );
  }

  Widget _buildGameModeRow({required String title}) {
    return GestureDetector(
      onTap: () {
        final mode = GameMode.values.firstWhere((gm) => gm.getLocalizedText(context) == title);
        
        setState(() {
          _selectedMode = mode;
        });

      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: _selectedMode.getLocalizedText(context) == title ? Theme.of(context).highlightColor : Colors.white.withAlpha(40),
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(15),
          
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
          ]
        ),
      ),
    );
  }
}