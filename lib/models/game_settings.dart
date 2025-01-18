import 'package:wordblock/models/game_mode.dart';

class GameSettings {
  final List<String> teamNames;
  final int timeLimit;
  final int skipsAllowed;
  final int numberOfTurns;
  final int maxPoints;
  final GameMode mode;

  const GameSettings({
    required this.teamNames,
    required this.timeLimit,
    required this.skipsAllowed,
    required this.numberOfTurns,
    required this.maxPoints,
    required this.mode,
  });
}