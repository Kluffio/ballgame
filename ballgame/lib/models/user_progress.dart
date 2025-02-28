import 'league.dart';

class UserProgress {
  static int totalScore = 0;
  static List<bool> unlockedLevels = List.generate(10, (index) => index < 1);

  static void unlockNextLevel(int currentLevel) {
    if (currentLevel < unlockedLevels.length - 1) {
      unlockedLevels[currentLevel + 1] = true;
    }
  }

  static bool isLeagueUnlocked(League league) {
    return totalScore >= league.requiredPoints;
  }

  static void addScore(int score) {
    totalScore += score;
  }
}
