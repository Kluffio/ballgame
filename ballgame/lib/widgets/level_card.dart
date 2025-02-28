import 'package:flutter/material.dart';
import '../models/game_level.dart';
import '../screens/game_screen.dart';

class LevelCard extends StatelessWidget {
  final GameLevel level;
  final int index;
  final bool isUnlocked;
  final Function refreshParent;

  const LevelCard({
    Key? key,
    required this.level,
    required this.index,
    required this.isUnlocked,
    required this.refreshParent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: isUnlocked
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(level: level),
                  ),
                ).then((_) {
                  // Обновляем состояние после возвращения из игры
                  refreshParent();
                });
              }
            : null,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isUnlocked
                    ? level.color.withOpacity(0.6)
                    : Colors.grey.withOpacity(0.6),
                isUnlocked ? level.color : Colors.grey,
              ],
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: isUnlocked
                    ? Text(
                        "${index + 1}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: level.color,
                        ),
                      )
                    : const Icon(Icons.lock, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Цель: ${level.targetScore} очков",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (level.hasMovingPlatforms)
                      const Text(
                        "Движущиеся платформы",
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                isUnlocked ? Icons.play_circle_filled : Icons.lock,
                color: Colors.white,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
