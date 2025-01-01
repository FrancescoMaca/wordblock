class TabooCard {
  final String mainWord;
  final List<String> forbiddenWords;

  TabooCard({
    required this.mainWord,
    required this.forbiddenWords,
  });

  factory TabooCard.fromCSV(List<dynamic> row) {
    try {
      return TabooCard(
        mainWord: row[0].toString().trim(),
        forbiddenWords: row.sublist(1, 6).map((e) => e.toString().trim()).toList(),
      );
    } catch (e) {
      return TabooCard(
        mainWord: "ERROR",
        forbiddenWords: ["Error loading card"],
      );
    }
  }

  @override
  String toString() {
    return 'TabooCard(mainWord: $mainWord, forbidden: $forbiddenWords)';
  }
}