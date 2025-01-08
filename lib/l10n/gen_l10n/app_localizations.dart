import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// The play button in the home screen
  ///
  /// In en, this message translates to:
  /// **'Play!'**
  String get button_play;

  /// The title of the game set up screen
  ///
  /// In en, this message translates to:
  /// **'Game Setup'**
  String get title_setup_game;

  /// The team title section
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get title_teams;

  /// The mode title section
  ///
  /// In en, this message translates to:
  /// **'Modes'**
  String get title_modes;

  /// The settings title section
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get title_settings;

  /// The part of the title when starting a game
  ///
  /// In en, this message translates to:
  /// **'SWIPE'**
  String get swipe;

  /// The part of the title when starting a game
  ///
  /// In en, this message translates to:
  /// **'DOWN'**
  String get down;

  /// The part of the title when starting a game
  ///
  /// In en, this message translates to:
  /// **'TO'**
  String get to;

  /// The part of the title when starting a game
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// The text when the game starts
  ///
  /// In en, this message translates to:
  /// **'Have fun'**
  String get title_have_fun;

  /// Swipe down label text
  ///
  /// In en, this message translates to:
  /// **'swipe down'**
  String get label_swipe_down;

  /// The label for round time
  ///
  /// In en, this message translates to:
  /// **'Round Time: {time} seconds'**
  String label_round_time(int time);

  /// The label for the skips allowed
  ///
  /// In en, this message translates to:
  /// **'Skips Allowed: {amount}'**
  String label_skips_allowed(int amount);

  /// The label for points needed to win
  ///
  /// In en, this message translates to:
  /// **'Points needed: {points}'**
  String label_points_needed(int points);

  /// The label for turns to finish the game
  ///
  /// In en, this message translates to:
  /// **'Number of turns: {turns}'**
  String label_number_of_turns(int turns);

  /// The label to add a team
  ///
  /// In en, this message translates to:
  /// **'Add Team'**
  String get label_add_team;

  /// The label to remove a team
  ///
  /// In en, this message translates to:
  /// **'Remove Team'**
  String get label_remove_team;

  /// The label to indicate the score obtained this round
  ///
  /// In en, this message translates to:
  /// **'Round Score:'**
  String get label_round_score;

  /// The label to indicate the amount of skips left
  ///
  /// In en, this message translates to:
  /// **'Skips Left:'**
  String get label_skips_left;

  /// The name of whose turn it is
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Turn'**
  String label_turn_of(String name);

  /// The label for the current scores
  ///
  /// In en, this message translates to:
  /// **'Current Scores'**
  String get label_current_scores;

  /// The label for the current turn out of the total turns
  ///
  /// In en, this message translates to:
  /// **'Turn {currentTurn} of {totalTurns}'**
  String label_turn_number(int currentTurn, int totalTurns);

  /// The helper label to explain how the targeted mode works
  ///
  /// In en, this message translates to:
  /// **'First to {maxPoints} points wins!'**
  String label_helper_targeted_mode(int maxPoints);

  /// The helper label to explain how the targeted mode works
  ///
  /// In en, this message translates to:
  /// **'Start Round'**
  String get label_start_round;

  /// The label for points needed to win
  ///
  /// In en, this message translates to:
  /// **'Please enter team {teamNumber} name'**
  String error_team_name(int teamNumber);

  /// The name for the targeted endless
  ///
  /// In en, this message translates to:
  /// **'Targeted'**
  String get mode_targeted;

  /// The name for the quick and easy endless
  ///
  /// In en, this message translates to:
  /// **'Quick \'n Easy'**
  String get mode_qne;

  /// The name for the endless endless
  ///
  /// In en, this message translates to:
  /// **'Endless'**
  String get mode_endless;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
