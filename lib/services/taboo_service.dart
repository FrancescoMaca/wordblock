import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:taboo/components/taboo_card.dart';

class TabooService {
  Future<List<TabooCard>> loadTabooCards(BuildContext context) async {
    try {
      final String fileContent = await DefaultAssetBundle.of(context).loadString('assets/words.csv');
      
      const csvConverter = CsvToListConverter(
          shouldParseNumbers: false,
          fieldDelimiter: ',',
          eol: '\n'
      );

      final List<List<dynamic>> csvData = csvConverter.convert(fileContent);
      
      // Skip the header row and convert each row to a TabooCard
      final cards = csvData.skip(1).map((row) => TabooCard.fromCSV(row)).toList();
      print("Loaded ${cards.length} cards successfully");
      return cards;
      
    } catch (e) {
      print('Error loading taboo cards: $e');
      return [];
    }
  }
}