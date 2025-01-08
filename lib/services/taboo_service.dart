import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taboo/components/taboo_card.dart';

class TabooService {
  Future<List<TabooCard>> loadTabooCards(BuildContext context) async {
    try {
      final langCode = Localizations.localeOf(context).languageCode;

      if (kDebugMode) {
        debugPrint('language code: $langCode');
      }

      final String fileContent = await DefaultAssetBundle.of(context).loadString('assets/words/words_$langCode.csv');
      
      const csvConverter = CsvToListConverter(
        shouldParseNumbers: false,
        fieldDelimiter: ',',
        eol: '\n'
      );

      final List<List<dynamic>> csvData = csvConverter.convert(fileContent);
      
      final cards = csvData.skip(1).map((row) => TabooCard.fromCSV(row)).toList();

      if (kDebugMode) {
        debugPrint("Loaded ${cards.length} cards successfully");
      }
      
      return cards;
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading taboo cards: $e');
      }
      return [];
    }
  }
}