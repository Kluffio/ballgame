import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Шарик в лунку',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const MainMenu(),
    );
  }
}

class League {
  final String name;
  final String description;
  final Color color;
  final int requiredPoints;
  final bool redObstaclesKill;
  final int redObstaclesPenalty;

  League({
    required this.name,
    required this.description,
    required this.color,
    required this.requiredPoints,
    required this.redObstaclesKill,
    required this.redObstaclesPenalty,
  });
}

class GameLevel {
  final String name;
  final String description;
  final Color color;
  final int obstacleFrequency;
  final double gravity;
  final double obstacleSpeed;
  final int targetScore;
  final bool hasMovingPlatforms;
  final League league;

  GameLevel({
    required this.name,
    required this.description,
    required this.color,
    required this.obstacleFrequency,
    required this.gravity,
    required this.obstacleSpeed,
    required this.targetScore,
    required this.hasMovingPlatforms,
    required this.league,
  });
}

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

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  static final List<League> leagues = [
    League(
      name: "Зелёная лига",
      description: "Уровни 1-5. Красные квадраты отнимают 50 очков.",
      color: Colors.green,
      requiredPoints: 0,
      redObstaclesKill: false,
      redObstaclesPenalty: 50,
    ),
    League(
      name: "Красная лига",
      description: "Уровни 6-10. Красные квадраты убивают игрока.",
      color: Colors.red,
      requiredPoints: 1500,
      redObstaclesKill: true,
      redObstaclesPenalty: 0,
    ),
  ];

  static List<GameLevel> levels = [
    // Зелёная лига (1-5)
    GameLevel(
      name: "Уровень 1",
      description: "Легкий старт для новичков",
      color: Colors.green,
      obstacleFrequency: 100,
      gravity: 0.002, // Облегченная гравитация
      obstacleSpeed: 0.005,
      targetScore: 150,
      hasMovingPlatforms: false,
      league: leagues[0],
    ),
    GameLevel(
      name: "Уровень 2",
      description: "Немного быстрее",
      color: Colors.lightGreen,
      obstacleFrequency: 90,
      gravity: 0.0025,
      obstacleSpeed: 0.006,
      targetScore: 200,
      hasMovingPlatforms: false,
      league: leagues[0],
    ),
    GameLevel(
      name: "Уровень 3",
      description: "Первые движущиеся платформы",
      color: Colors.lightBlue,
      obstacleFrequency: 80,
      gravity: 0.003,
      obstacleSpeed: 0.007,
      targetScore: 250,
      hasMovingPlatforms: true, // Добавляем движущиеся платформы
      league: leagues[0],
    ),
    GameLevel(
      name: "Уровень 4",
      description: "Будь осторожен!",
      color: Colors.amber,
      obstacleFrequency: 70,
      gravity: 0.0035,
      obstacleSpeed: 0.008,
      targetScore: 300,
      hasMovingPlatforms: true,
      league: leagues[0],
    ),
    GameLevel(
      name: "Уровень 5",
      description: "Финал зелёной лиги",
      color: Colors.orange,
      obstacleFrequency: 60,
      gravity: 0.004,
      obstacleSpeed: 0.009,
      targetScore: 350,
      hasMovingPlatforms: true,
      league: leagues[0],
    ),
    // Красная лига (6-10)
    GameLevel(
      name: "Уровень 6",
      description: "Начало красной лиги!",
      color: Colors.pink[300]!,
      obstacleFrequency: 55,
      gravity: 0.0045,
      obstacleSpeed: 0.01,
      targetScore: 400,
      hasMovingPlatforms: true,
      league: leagues[1],
    ),
    GameLevel(
      name: "Уровень 7",
      description: "Сложные платформы",
      color: Colors.deepPurple[300]!,
      obstacleFrequency: 50,
      gravity: 0.005,
      obstacleSpeed: 0.012,
      targetScore: 450,
      hasMovingPlatforms: true,
      league: leagues[1],
    ),
    GameLevel(
      name: "Уровень 8",
      description: "Будь очень аккуратен",
      color: Colors.red[400]!,
      obstacleFrequency: 45,
      gravity: 0.0055,
      obstacleSpeed: 0.014,
      targetScore: 500,
      hasMovingPlatforms: true,
      league: leagues[1],
    ),
    GameLevel(
      name: "Уровень 9",
      description: "Для настоящих мастеров",
      color: Colors.red[600]!,
      obstacleFrequency: 40,
      gravity: 0.006,
      obstacleSpeed: 0.016,
      targetScore: 550,
      hasMovingPlatforms: true,
      league: leagues[1],
    ),
    GameLevel(
      name: "Уровень 10",
      description: "Высший уровень сложности!",
      color: Colors.red[900]!,
      obstacleFrequency: 35,
      gravity: 0.0065,
      obstacleSpeed: 0.018,
      targetScore: 600,
      hasMovingPlatforms: true,
      league: leagues[1],
    ),
  ];

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu>
    with SingleTickerProviderStateMixin {
  int selectedLeagueIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: MainMenu.leagues.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedLeagueIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Шарик в лунку"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: MainMenu.leagues.map((league) {
            bool isUnlocked = UserProgress.isLeagueUnlocked(league);
            return Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(league.name),
                  if (!isUnlocked) const SizedBox(width: 5),
                  if (!isUnlocked) const Icon(Icons.lock, size: 16),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.blue[300]!],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Общий счет игрока
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "Всего очков: ${UserProgress.totalScore}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Описание лиги
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: MainMenu.leagues[selectedLeagueIndex].color
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: MainMenu.leagues[selectedLeagueIndex].color,
                  width: 2,
                ),
              ),
              child: Text(
                MainMenu.leagues[selectedLeagueIndex].description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: MainMenu.leagues.map((league) {
                  bool isLeagueUnlocked = UserProgress.isLeagueUnlocked(league);

                  if (!isLeagueUnlocked) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock,
                                size: 50, color: Colors.grey),
                            const SizedBox(height: 20),
                            Text(
                              "${league.name} заблокирована",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Необходимо набрать ${league.requiredPoints} очков",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "У вас сейчас: ${UserProgress.totalScore} очков",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Пройдите предыдущие уровни, чтобы разблокировать эту лигу",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Отфильтруем уровни, соответствующие текущей лиге
                  final leagueLevels = MainMenu.levels
                      .where((level) => level.league == league)
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: leagueLevels.length,
                    itemBuilder: (context, index) {
                      final level = leagueLevels[index];
                      final levelIndex = MainMenu.levels.indexOf(level);
                      final isUnlocked =
                          UserProgress.unlockedLevels[levelIndex];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: LevelCard(
                          level: level,
                          index: levelIndex,
                          isUnlocked: isUnlocked,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LevelCard extends StatelessWidget {
  final GameLevel level;
  final int index;
  final bool isUnlocked;

  const LevelCard({
    Key? key,
    required this.level,
    required this.index,
    required this.isUnlocked,
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
                  if (context.findAncestorStateOfType<_MainMenuState>() !=
                      null) {
                    context
                        .findAncestorStateOfType<_MainMenuState>()!
                        .setState(() {});
                  }
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

class Obstacle {
  double x;
  double y;
  double size;
  double speedY;
  Color color;
  bool isBonus; // Зелёные квадраты - бонусы, красные - штрафы
  bool isMovingPlatform;
  double speedX; // Для движущихся платформ
  double amplitude; // Амплитуда движения для платформ
  double originalX; // Исходная X-позиция для платформ

  Obstacle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedY,
    required this.color,
    required this.isBonus,
    this.isMovingPlatform = false,
    this.speedX = 0.0,
    this.amplitude = 0.0,
    this.originalX = 0.0,
  });
}

class GameScreen extends StatefulWidget {
  final GameLevel level;

  const GameScreen({Key? key, required this.level}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Позиция шарика
  double ballX = 0.0;
  double ballY = 0.0;

  // Позиция лунки
  double holeX = 0.0;
  double holeY = -0.5;

  // Размеры
  double ballSize = 30.0;
  double holeSize = 40.0;
  double obstacleBaseSize = 35.0;

  // Скорость и направление движения
  double ballSpeedX = 0.0;
  double ballSpeedY = 0.0;
  double jumpForce = -0.04; // Увеличенная сила прыжка
  double diagonalForce = 0.025; // Увеличенная сила бокового движения

  // Препятствия
  List<Obstacle> obstacles = [];
  int frameCount = 0;

  // Статус игры
  bool gameOver = false;
  bool gameWon = false;
  bool levelCompleted = false;
  int score = 0;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Генерируем случайную позицию для лунки
    final random = Random();
    holeX = random.nextDouble() * 1.5 - 0.75; // От -0.75 до 0.75

    // Настраиваем таймер для обновления игры
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _controller.addListener(_updateGame);
  }

  void _updateGame() {
    if (gameOver) return;

    setState(() {
      frameCount++;

      // Создаем новые препятствия с частотой, зависящей от уровня
      if (frameCount % widget.level.obstacleFrequency == 0) {
        _addObstacle();
      }

      // Обновляем позиции препятствий
      _updateObstacles();

      // Применяем гравитацию, зависящую от уровня
      ballSpeedY += widget.level.gravity;

      // Обновляем позицию шарика
      ballX += ballSpeedX;
      ballY += ballSpeedY;

      // Проверяем столкновения со стенками
      if (ballX < -1.0) {
        ballX = -1.0;
        ballSpeedX *= -0.7; // Отскок с затуханием
      } else if (ballX > 1.0) {
        ballX = 1.0;
        ballSpeedX *= -0.7;
      }

      // Проверка на дно экрана
      if (ballY > 1.0) {
        ballY = 1.0;
        ballSpeedY *= -0.7;
        // Трение о поверхность
        ballSpeedX *= 0.95;
      }

      // Проверяем столкновения с препятствиями
      _checkObstacleCollisions();

      // Проверяем попадание в лунку
      final distance = sqrt(pow(ballX - holeX, 2) + pow(ballY - holeY, 2));
      if (distance < 0.1) {
        gameOver = true;
        gameWon = true;
        score += 100; // За уровень +100 очков

        // Проверяем, выполнена ли цель уровня
        if (score >= widget.level.targetScore) {
          levelCompleted = true;
          // Разблокируем следующий уровень
          int currentIndex = MainMenu.levels.indexOf(widget.level);
          UserProgress.unlockNextLevel(currentIndex);
          // Добавляем очки к общему счету
          UserProgress.addScore(score);
        }

        _controller.stop();
      }

      // Замедление движения для реалистичности
      ballSpeedX *= 0.99;
      ballSpeedY *= 0.99;
    });
  }

  void _addObstacle() {
    final random = Random();

    // Случайная позиция по X
    double obstacleX = random.nextDouble() * 1.8 - 0.9; // От -0.9 до 0.9

    // Случайный размер
    double size = obstacleBaseSize + random.nextDouble() * 15;

    // Скорость зависит от уровня
    double speedY = widget.level.obstacleSpeed + random.nextDouble() * 0.01;

    // Случайно определяем тип препятствия (бонус/штраф)
    bool isBonus = random.nextDouble() > 0.5;
    Color color = isBonus ? Colors.green : Colors.red;

    // Определяем, будет ли это движущаяся платформа
    bool isMovingPlatform =
        widget.level.hasMovingPlatforms && random.nextDouble() > 0.7;
    double speedX = 0.0;
    double amplitude = 0.0;

    if (isMovingPlatform) {
      speedX = 0.01 + random.nextDouble() * 0.02;
      if (random.nextBool()) speedX *= -1;
      amplitude = 0.3 + random.nextDouble() * 0.4;
    }

    obstacles.add(Obstacle(
      x: obstacleX,
      y: -1.2, // Начинаем над экраном
      size: size,
      speedY: speedY,
      color: color,
      isBonus: isBonus,
      isMovingPlatform: isMovingPlatform,
      speedX: speedX,
      amplitude: amplitude,
      originalX: obstacleX,
    ));
  }

  void _updateObstacles() {
    // Обновляем позиции препятствий и удаляем те, что вышли за пределы экрана
    obstacles.removeWhere((obstacle) {
      obstacle.y += obstacle.speedY;

      // Обновляем позицию для движущихся платформ
      if (obstacle.isMovingPlatform) {
        // Двигаем платформу по синусоиде
        if (obstacle.originalX == 0) obstacle.originalX = obstacle.x;
        obstacle.x = obstacle.originalX +
            sin(frameCount * obstacle.speedX) * obstacle.amplitude;

        // Ограничиваем движение в пределах экрана
        if (obstacle.x < -1.0) obstacle.x = -1.0;
        if (obstacle.x > 1.0) obstacle.x = 1.0;
      }

      return obstacle.y > 1.5; // Удаляем, если вышел за нижнюю границу
    });
  }

  void _checkObstacleCollisions() {
    for (var obstacle in obstacles) {
      final distance =
          sqrt(pow(ballX - obstacle.x, 2) + pow(ballY - obstacle.y, 2));
      double collisionDistance =
          (ballSize + obstacle.size) / 2 / MediaQuery.of(context).size.width;

      if (distance < collisionDistance) {
        if (obstacle.isBonus) {
          // Зеленый квадрат - бонус
          score += 25; // +25 очков
          obstacles.remove(obstacle);
          break;
        } else {
          // Красный квадрат - штраф или смерть
          if (widget.level.league.redObstaclesKill) {
            // В красной лиге красные квадраты убивают
            gameOver = true;
            gameWon = false;
            _controller.stop();
            break;
          } else {
            // В зеленой лиге красные квадраты отнимают очки
            score -= widget.level.league.redObstaclesPenalty;
            if (score < 0) score = 0;

            // Отскок от препятствия
            double angle = atan2(ballY - obstacle.y, ballX - obstacle.x);
            ballSpeedX = cos(angle) * 0.05;
            ballSpeedY = sin(angle) * 0.05;

            obstacles.remove(obstacle);
            break;
          }
        }
      }
    }
  }

  void _jumpLeft() {
    if (gameOver) return;

    setState(() {
      // Прыжок по диагонали влево и вверх
      ballSpeedY = jumpForce;
      ballSpeedX = -diagonalForce;
    });
  }

  void _jumpRight() {
    if (gameOver) return;

    setState(() {
      // Прыжок по диагонали вправо и вверх
      ballSpeedY = jumpForce;
      ballSpeedX = diagonalForce;
    });
  }

  void _resetGame() {
    setState(() {
      ballX = 0.0;
      ballY = 0.0;
      ballSpeedX = 0.0;
      ballSpeedY = 0.0;

      // Новая случайная позиция для лунки
      final random = Random();
      holeX = random.nextDouble() * 1.5 - 0.75;

      // Очищаем препятствия
      obstacles.clear();

      gameOver = false;
      gameWon = false;

      // Сбрасываем счет только при проигрыше
      if (!gameWon) {
        score = 0;
      }

      _controller.repeat();
    });
  }

  void _goToNextLevel(BuildContext context) {
    // Найти текущий индекс уровня
    int currentIndex = MainMenu.levels.indexOf(widget.level);

    // Проверить, есть ли следующий уровень
    if (currentIndex < MainMenu.levels.length - 1 &&
        UserProgress.unlockedLevels[currentIndex + 1]) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GameScreen(level: MainMenu.levels[currentIndex + 1]),
        ),
      );
    } else {
      // Это был последний уровень или следующий заблокирован, возвращаемся в меню
      _returnToMenu(context);
    }
  }

  void _returnToMenu(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainMenu(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.level.name),
        backgroundColor: widget.level.color,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Цель: ${widget.level.targetScore} / Счет: $score',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue[100],
              child: Stack(
                children: [
                  // Лунка
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 0),
                    left: MediaQuery.of(context).size.width *
                            (holeX * 0.5 + 0.5) -
                        holeSize / 2,
                    top: MediaQuery.of(context).size.height *
                            (holeY * 0.5 + 0.5) -
                        holeSize / 2,
                    child: Container(
                      width: holeSize,
                      height: holeSize,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Препятствия
                  ...obstacles.map((obstacle) {
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 0),
                      left: MediaQuery.of(context).size.width *
                              (obstacle.x * 0.5 + 0.5) -
                          obstacle.size / 2,
                      top: MediaQuery.of(context).size.height *
                              (obstacle.y * 0.5 + 0.5) -
                          obstacle.size / 2,
                      child: Container(
                        width: obstacle.size,
                        height: obstacle.size,
                        decoration: BoxDecoration(
                          color: obstacle.color,
                          borderRadius: BorderRadius.circular(
                              obstacle.isMovingPlatform ? 5 : 15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: obstacle.isBonus
                            ? const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  }).toList(),

                  // Шарик
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 0),
                    left: MediaQuery.of(context).size.width *
                            (ballX * 0.5 + 0.5) -
                        ballSize / 2,
                    top: MediaQuery.of(context).size.height *
                            (ballY * 0.5 + 0.5) -
                        ballSize / 2,
                    child: Container(
                      width: ballSize,
                      height: ballSize,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Colors.blue[300]!, Colors.blue[700]!],
                          center: Alignment.topLeft,
                          radius: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Игровое сообщение
                  if (gameOver)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              gameWon ? "Уровень пройден!" : "Игра окончена!",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Ваш счет: $score",
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Цель уровня: ${widget.level.targetScore}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 20),
                            levelCompleted
                                ? Text(
                                    "Уровень успешно пройден!",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  )
                                : Text(
                                    gameWon
                                        ? "Не хватило очков для прохождения!"
                                        : "Попробуйте ещё раз!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          gameWon ? Colors.yellow : Colors.red,
                                    ),
                                  ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (gameWon && levelCompleted)
                                  ElevatedButton(
                                    onPressed: () => _goToNextLevel(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                    ),
                                    child: const Text(
                                      "Следующий уровень",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                if (gameWon && !levelCompleted) ...[
                                  ElevatedButton(
                                    onPressed: _resetGame,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                    ),
                                    child: const Text(
                                      "Повторить",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                if (!gameWon)
                                  ElevatedButton(
                                    onPressed: _resetGame,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                    ),
                                    child: const Text(
                                      "Повторить",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () => _returnToMenu(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                  ),
                                  child: const Text(
                                    "В меню",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Счетчик очков
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "Счет: $score",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Кнопки управления
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.blue[800],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _jumpLeft(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _returnToMenu(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "В меню",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _jumpRight(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
