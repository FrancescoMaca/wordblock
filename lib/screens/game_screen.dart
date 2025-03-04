import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordblock/audio/audio_service.dart';
import 'package:wordblock/components/challenge_card.dart';
import 'package:wordblock/components/game_button.dart';
import 'package:wordblock/l10n/gen_l10n/app_localizations.dart';
import 'package:wordblock/models/game_mode.dart';
import 'package:wordblock/models/game_settings.dart';
import 'package:wordblock/screens/menu_screen.dart';
import 'package:wordblock/screens/victory_screen.dart';
import 'package:wordblock/services/wordblock_service.dart';
import 'package:wordblock/themes/theme.dart';

class WordBlockGameScreen extends StatefulWidget {
  final GameSettings settings;
  
  const WordBlockGameScreen({
    super.key,
    required this.settings,
  });

  @override
  State<WordBlockGameScreen> createState() => _WordBlockGameScreenState();
}

class _WordBlockGameScreenState extends State<WordBlockGameScreen> {
  final WordblockService _wordblockService = WordblockService();
  List<ChallengeCard> cards = [];
  int currentCardIndex = 0;
  late List<int> teamScores;
  int currentTeamIndex = 0;
  int _turnsPlayed = 0;

  Timer? _timer;
  late int _secondsLeft;
  late int _skipsLeft;
  bool _isPlaying = false;
  int _roundScore = 0;

  @override
  void initState() {
    super.initState();
    AudioService.instance.stopSoundtrack();
    _secondsLeft = widget.settings.timeLimit;
    _skipsLeft = widget.settings.skipsAllowed;
    teamScores = List.filled(widget.settings.teamNames.length, 0);
  }

  // Need this to load cards
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadCards();
  }

  Future<void> _loadCards() async {    
    final loadedCards = await _wordblockService.loadCards(context);
    setState(() {
      cards = loadedCards;
      cards.shuffle();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showQuitConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Quit Game?',
          style: Theme.of(context).textTheme.titleMedium
        ),
        content: Text(
          'Are you sure you want to quit? Your progress will be lost.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.bodySmall
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                'Quit', 
                style: Theme.of(context).textTheme.bodySmall
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startRound() {
    setState(() {
      _isPlaying = true;
      _secondsLeft = widget.settings.timeLimit;
      _skipsLeft = widget.settings.skipsAllowed;
      _roundScore = 0;
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          setState(() {
            if (_secondsLeft > 0) {
              _secondsLeft--;
              if (_secondsLeft == 10) {
                AudioService.instance.play('low_on_time.mp3');  
              }

              if (_secondsLeft < 10) {
                HapticFeedback.heavyImpact();
              }
            } else {
              _endRound();
            }
          });
        },
      );
    });
  }

  void _endRound() {
    _timer?.cancel();
    _nextCard();
    setState(() {
      _isPlaying = false;
      teamScores[currentTeamIndex] += _roundScore;
      _turnsPlayed++;

      if (widget.settings.mode == GameMode.quick && _turnsPlayed >= widget.settings.numberOfTurns) {
        _showVictoryScreen();
      } else if (widget.settings.mode == GameMode.targeted && 
          teamScores[currentTeamIndex] >= widget.settings.maxPoints) {
        _showVictoryScreen();
      } else {
        currentTeamIndex = (currentTeamIndex + 1) % widget.settings.teamNames.length;
      }
    });
  }

  void _showVictoryScreen() {
    final winningTeamIndex = teamScores.indexOf(teamScores.reduce((a, b) => a > b ? a : b));
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VictoryScreen(
          winningTeam: widget.settings.teamNames[winningTeamIndex],
          winningScore: teamScores[winningTeamIndex],
          teamNames: widget.settings.teamNames,
          teamScores: teamScores,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return !_isPlaying ? _buildStartScreen() : _buildGameScreen();
  }

  Widget _buildGameScreen() {
    final currentCard = cards[currentCardIndex];
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppTheme.backgroundGradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.exit_to_app, color: Colors.white),
                    onPressed: _showQuitConfirmDialog,
                  ),
                  _buildScoreBoard(),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 16),
              _buildGameInfo(),
              const SizedBox(height: 24),
              Expanded(
                child: _buildCard(currentCard),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.settings.teamNames.length <= 3) ...[
              // For 2-3 teams: Show current team and next team
              Expanded(
                child: _buildTeamScore(
                  widget.settings.teamNames[currentTeamIndex],
                  teamScores[currentTeamIndex],
                  true,
                ),
              ),
              const SizedBox(width: 10),
              _buildTimer(),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTeamScore(
                  widget.settings.teamNames[(currentTeamIndex + 1) % widget.settings.teamNames.length],
                  teamScores[(currentTeamIndex + 1) % widget.settings.teamNames.length],
                  false,
                ),
              ),
            ] else ...[
              // For 4 teams: Show current team and timer only
              Expanded(
                child: _buildTeamScore(
                  widget.settings.teamNames[currentTeamIndex],
                  teamScores[currentTeamIndex],
                  true,
                ),
              ),
              const SizedBox(width: 10),
              _buildTimer(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGameInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoCard(AppLocalizations.of(context).label_round_score,  _roundScore.toString()),
        _buildInfoCard(AppLocalizations.of(context).label_skips_left, _skipsLeft.toString()),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(ChallengeCard card) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius * 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 250,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppTheme.borderRadius * 2),
              ),
            ),
            child: Text(
              card.mainWord.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: card.forbiddenWords.map((word) => 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    word.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).highlightColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GameButton(
            icon: Icons.skip_next,
            label: 'Skip',
            color: _skipsLeft > 0 ? Colors.orange : Colors.grey,
            onPressed: _skipsLeft > 0 ? () async {
              await AudioService.instance.play('skip_answer.mp3');
              setState(() {
                _skipsLeft--;
                _nextCard();
              });
            } : null,
          ),
          GameButton(
            icon: Icons.check_circle,
            label: 'Guessed',
            color: Colors.green,
            defaultSize: 72,
            onPressed: () async {
              await AudioService.instance.play('correct_answer.mp3');

              setState(() {
                _roundScore++;
                _nextCard();
              });
            },
          ),
          GameButton(
            icon: Icons.dangerous,
            color: Colors.red,
            label: 'Penalty',
            onPressed: () async {
              await AudioService.instance.play('blocked_answer.mp3');

              setState(() {
                _roundScore--;
                _nextCard();
              });
            },
          ),
        ],
      ),
    );
  }
  String _trimTeamName(String name) {
    return name.length < 9 ? name : '${name.substring(0, 9)}...';
  }

  Widget _buildTimer() {
    final isLowTime = _secondsLeft <= 10;
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isLowTime ? Colors.red.withOpacity(0.2) : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(
          color: isLowTime ? Colors.red : Colors.white.withOpacity(0.2),
        ),
      ),
      child: Text(
        _secondsLeft.toString(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontSize: 36,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStartScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppTheme.backgroundGradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.exit_to_app, color: Colors.white),
                      onPressed: _showQuitConfirmDialog,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).label_turn_of(_trimTeamName(widget.settings.teamNames[currentTeamIndex])),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 48,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      if (widget.settings.mode == GameMode.quick)
                        Text(
                          AppLocalizations.of(context).label_turn_number(_turnsPlayed + 1, widget.settings.numberOfTurns),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        )
                      else if (widget.settings.mode == GameMode.targeted)
                        Text(
                          AppLocalizations.of(context).label_helper_targeted_mode(widget.settings.maxPoints),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      const SizedBox(height: 48),
                      _buildScoresTable(),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: _startRound,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                        ),
                        child: Text(
                          AppLocalizations.of(context).label_start_round,
                          style: Theme.of(context).textTheme.titleMedium
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoresTable() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).label_current_scores,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          widget.settings.teamNames.length <= 2
              ? _buildTwoTeamsScores()
              : _buildMultiTeamScores(),
        ],
      ),
    );
  }

  Widget _buildTwoTeamsScores() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTeamScoreCompact(
          widget.settings.teamNames[0],
          teamScores[0],
        ),
        const SizedBox(width: 20),
        const Text(
          'vs',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        const SizedBox(width: 20),
        _buildTeamScoreCompact(
          widget.settings.teamNames[1],
          teamScores[1],
        ),
      ],
    );
  }

  Widget _buildMultiTeamScores() {
    // Grid layout for 3-4 teams
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: widget.settings.teamNames.length,
      itemBuilder: (context, index) {
        return _buildTeamScoreCompact(
          widget.settings.teamNames[index],
          teamScores[index],
        );
      },
    );
  }

  Widget _buildTeamScore(String team, int score, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: isActive ? Border.all(color: Colors.white.withOpacity(0.2)) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            team,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamScoreCompact(String team, int score) {
    return Container(
      decoration: BoxDecoration(
        color: currentTeamIndex == widget.settings.teamNames.indexOf(team)
            ? Colors.white.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            team,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            score.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
  
  void _nextCard() {
    setState(() {
      currentCardIndex = (currentCardIndex + 1) % cards.length;
    });
  }
}