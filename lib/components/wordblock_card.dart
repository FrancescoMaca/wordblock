class WordBlockCard {
  final String mainWord;
  final List<String> forbiddenWords;

  WordBlockCard({
    required this.mainWord,
    required this.forbiddenWords,
  });

  factory WordBlockCard.fromCSV(List<dynamic> row) {
    try {
      return WordBlockCard(
        mainWord: row[0].toString().trim(),
        forbiddenWords: row.sublist(1, 6).map((e) => e.toString().trim()).toList(),
      );
    } catch (e) {
      return WordBlockCard(
        mainWord: "ERROR",
        forbiddenWords: ["Error loading card"],
      );
    }
  }

  @override
  String toString() {
    return 'WordBlockCard(mainWord: $mainWord, forbidden: $forbiddenWords)';
  }
}