import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get button_play => 'Gioca!';

  @override
  String get title_setup_game => 'Imposta Partita';

  @override
  String get title_teams => 'Teams';

  @override
  String get title_modes => 'Modalità';

  @override
  String get title_settings => 'Opzioni';

  @override
  String get swipe => 'SCROLLA';

  @override
  String get down => 'GIU';

  @override
  String get to => 'PER';

  @override
  String get start => 'INIZIARE';

  @override
  String get title_have_fun => 'Divertiti';

  @override
  String get label_swipe_down => 'Scorri giu';

  @override
  String label_round_time(int time) {
    return 'Tempo ogni turno: $time secondi';
  }

  @override
  String label_skips_allowed(int amount) {
    return 'Salta turni: $amount';
  }

  @override
  String label_points_needed(int points) {
    return 'Punti per vincere: $points';
  }

  @override
  String label_number_of_turns(int turns) {
    return 'Numero di turni: $turns';
  }

  @override
  String get label_add_team => 'Aggiungi team';

  @override
  String get label_remove_team => 'Rimuovi team';

  @override
  String get label_round_score => 'Punti Turno:';

  @override
  String get label_skips_left => 'Salti rimanenti:';

  @override
  String label_turn_of(String name) {
    return 'Turno di $name';
  }

  @override
  String get label_current_scores => 'Punteggio';

  @override
  String label_turn_number(int currentTurn, int totalTurns) {
    return 'Turno $currentTurn su $totalTurns';
  }

  @override
  String label_helper_targeted_mode(int maxPoints) {
    return 'Il primo a raggiungere $maxPoints punti vince!';
  }

  @override
  String get label_start_round => 'Inizia il round';

  @override
  String error_team_name(int teamNumber) {
    return 'Inserisci il nome del team $teamNumber';
  }

  @override
  String get mode_targeted => 'A Punti';

  @override
  String get mode_qne => 'Facile e veloce';

  @override
  String get mode_endless => 'Infinita';

  @override
  String get mode_targeted_description => 'Corri verso il punteggio obiettivo! Vince la squadra che raggiunge per prima i punti richiesti.';

  @override
  String get mode_qne_description => 'Gioca un numero fisso di turni! Ogni squadra si alterna fino al completamento dei round. Perfetto per una partita veloce.';

  @override
  String get mode_endless_description => 'Continua a giocare quanto vuoi! Nessun limite di round o punteggio obiettivo. Puro divertimento senza fine.';
}
