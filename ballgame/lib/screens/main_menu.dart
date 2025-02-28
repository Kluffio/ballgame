import 'package:flutter/material.dart';
import '../data/data-levels.dart';
import '../models/user_progress.dart';
import '../widgets/level_card.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Шарик в лунку'),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[300]!, Colors.blue[800]!],
          ),
        ),
        child: Column(
          children: [
            // Статистика пользователя
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Общий счет:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${UserProgress.totalScore} очков',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Открыто уровней:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${UserProgress.unlockedLevels.where((level) => level).length} из ${UserProgress.unlockedLevels.length}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Заголовок лиг
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: LevelsData.leagues[0].color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LevelsData.leagues[0].name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: LevelsData.leagues[0].color,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: LevelsData.leagues[0].color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Открыто',
                      style: TextStyle(
                        color: LevelsData.leagues[0].color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Список уровней
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: LevelsData.levels.length,
                itemBuilder: (context, index) {
                  final level = LevelsData.levels[index];
                  
                  // Отображаем заголовок лиги
                  if (index == 5) {
                    // Красная лига начинается с 6-го уровня (индекс 5)
                    bool isRedLeagueUnlocked = UserProgress.isLeagueUnlocked(LevelsData.leagues[1]);
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: LevelsData.leagues[1].color,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                LevelsData.leagues[1].name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: LevelsData.leagues[1].color,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isRedLeagueUnlocked
                                      ? LevelsData.leagues[1].color.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  isRedLeagueUnlocked
                                      ? 'Открыто'
                                      : 'Нужно ${LevelsData.leagues[1].requiredPoints} очков',
                                  style: TextStyle(
                                    color: isRedLeagueUnlocked
                                        ? LevelsData.leagues[1].color
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        LevelCard(
                          level: level,
                          index: index,
                          isUnlocked: UserProgress.unlockedLevels[index] &&
                              UserProgress.isLeagueUnlocked(level.league),
                          refreshParent: () {
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: LevelCard(
                      level: level,
                      index: index,
                      isUnlocked: UserProgress.unlockedLevels[index] &&
                          UserProgress.isLeagueUnlocked(level.league),
                      refreshParent: () {
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
