import 'package:flutter/material.dart';
import 'package:verboten/l10n/gen_l10n/app_localizations.dart';

enum GameMode {
  targeted('Targeted'),
  quick('Quick \'n Easy'),
  endless('Endless');

  final String text;

  const GameMode(this.text);

  String getLocalizedText(BuildContext context) {
    switch (this) {
      case GameMode.targeted:
        return AppLocalizations.of(context).mode_targeted;
      case GameMode.quick:
        return AppLocalizations.of(context).mode_qne;
      case GameMode.endless:
        return AppLocalizations.of(context).mode_endless;
    }
  }

  String getLocalizedDescription(BuildContext context) {
    switch (this) {
      case GameMode.targeted:
        return AppLocalizations.of(context).mode_targeted_description;
      case GameMode.quick:
        return AppLocalizations.of(context).mode_qne_description;
      case GameMode.endless:
        return AppLocalizations.of(context).mode_endless_description;
    }
  }
}