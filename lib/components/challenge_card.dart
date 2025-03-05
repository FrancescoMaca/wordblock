class ChallengeCard {
  final String mainWord;
  final List<String> forbiddenWords;

  ChallengeCard({
    required this.mainWord,
    required this.forbiddenWords,
  });

  factory ChallengeCard.fromCSV(List<dynamic> row) {
    try {
      return ChallengeCard(
        mainWord: row[0].toString().trim(),
        forbiddenWords: row.sublist(1, 6).map((e) => e.toString().trim()).toList(),
      );
    } catch (e) {
      return ChallengeCard(
        mainWord: "ERROR",
        forbiddenWords: ["Error loading card"],
      );
    }
  }

  @override
  String toString() {
    return 'ChallengeCard(mainWord: $mainWord, forbidden: $forbiddenWords)';
  }
}