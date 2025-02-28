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

// Перечисление лиг для более четкой структуры
enum League {
  Green,
  Red,
}

class GameLevel {
  final String name;
  final String description;
  final Color color;
  final int obstacleFrequency;
  final double gravity;
  final double obstacleSpeed;
  final int targetScore;
  final League league; // Добавляем лигу к уровню
  final bool hasPlatforms; // Добавляем признак наличия платформ

  GameLevel({
    required this.name,
    required this.description,
    required this.color,
    required this.obstacleFrequency,
    required this.gravity,
    required this.obstacleSpeed,
    required this.targetScore,
    required this.league,
    this.hasPlatforms = false,
  });
}

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  League selectedLeague = League.Green; // По умолчанию выбрана зеленая лига
  int totalScore = 0; // Общий счет игрока
  bool isRedLeagueUnlocked = false; // Разблокирована ли красная лига

  // Уровни зеленой лиги
  static List<GameLevel> greenLeagueLevels = [
    GameLevel(
      name: "Уровень 1",
      description: "Легкий старт для новичков",
      color: Colors.green,
      obstacleFrequency: 100,
      gravity: 0.002, // Уменьшаем гравитацию для облегчения прыжков
      obstacleSpeed: 0.005,
      targetScore: 150,
      league: League.Green,
    ),
    GameLevel(
      name: "Уровень 2",
      description: "Немного быстрее",
      color: Colors.lightGreen,
      obstacleFrequency: 80,
      gravity: 0.0025,
      obstacleSpeed: 0.008,
      targetScore: 250,
      league: League.Green,
    ),
    GameLevel(
      name: "Уровень 3",
      description: "Будь осторожен!",
      color: Colors.green.shade600,
      obstacleFrequency: 70,
      gravity: 0.003,
      obstacleSpeed: 0.01,
      targetScore: 350,
      league: League.Green,
      hasPlatforms: true, // Добавляем платформы
    ),
    GameLevel(
      name: "Уровень 4",
      description: "Ловко прыгай!",
      color: Colors.green.shade700,
      obstacleFrequency: 60,
      gravity: 0.0035,
      obstacleSpeed: 0.012,
      targetScore: 450,
      league: League.Green,
      hasPlatforms: true,
    ),
    GameLevel(
      name: "Уровень 5",
      description: "Финал зеленой лиги!",
      color: Colors.green.shade900,
      obstacleFrequency: 50,
      gravity: 0.004,
      obstacleSpeed: 0.015,
      targetScore: 600,
      league: League.Green,
      hasPlatforms: true,
    ),
  ];

  // Уровни красной лиги (более сложные)
  static List<GameLevel> redLeagueLevels = [
    GameLevel(
      name: "Уровень 6",
      description: "Добро пожаловать в ад",
      color: Colors.red.shade300,
      obstacleFrequency: 45,
      gravity: 0.0045,
      obstacleSpeed: 0.018,
      targetScore: 700,
      league: League.Red,
      hasPlatforms: true,
    ),
    GameLevel(
      name: "Уровень 7",
      description: "Красная зона",
      color: Colors.red.shade400,
      obstacleFrequency: 40,
      gravity: 0.005,
      obstacleSpeed: 0.02,
      targetScore: 800,
      league: League.Red,
      hasPlatforms: true,
    ),
    GameLevel(
      name: "Уровень 8",
      description: "Выживание",
      color: Colors.red.shade600,
      obstacleFrequency: 35,
      gravity: 0.0055,
      obstacleSpeed: 0.022,
      targetScore: 900,
      league: League.Red,
      hasPlatforms: true,
    ),
    GameLevel(
      name: "Уровень 9",
      description: "Почти невозможный",
      color: Colors.red.shade700,
      obstacleFrequency: 30,
      gravity: 0.006,
      obstacleSpeed: 0.025,
      targetScore: 1000,
      league: League.Red,
      hasPlatforms: true,
    ),
    GameLevel(
      name: "Уровень 10",
      description: "Мастер игры",
      color: Colors.red.shade900,
      obstacleFrequency: 25,
      gravity: 0.0065,
      obstacleSpeed: 0.03,
      targetScore: 1200,
      league: League.Red,
      hasPlatforms: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Здесь можно было бы загрузить сохраненные данные
    // Проверим, доступна ли красная лига (допустим, если набрано 2000 очков)
    if (totalScore >= 2000) {
      isRedLeagueUnlocked = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Определяем список уровней в зависимости от выбранной лиги
    List<GameLevel> levels =
        selectedLeague == League.Green ? greenLeagueLevels : redLeagueLevels;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Шарик в лунку"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: selectedLeague == League.Green
                ? [Colors.blue[100]!, Colors.green[300]!]
                : [Colors.orange[100]!, Colors.red[300]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Общий счет: $totalScore",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: selectedLeague == League.Green
                      ? Colors.green[800]
                      : Colors.red[800],
                ),
              ),
              const SizedBox(height: 10),

              // Переключатель лиг
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedLeague = League.Green;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedLeague == League.Green
                          ? Colors.green
                          : Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text("Зеленая лига"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isRedLeagueUnlocked
                        ? () {
                            setState(() {
                              selectedLeague = League.Red;
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedLeague == League.Red
                          ? Colors.red
                          : Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: Text(isRedLeagueUnlocked
                        ? "Красная лига"
                        : "Красная лига (нужно 2000 очков)"),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text(
                "Выберите уровень",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: selectedLeague == League.Green
                      ? Colors.green[800]
                      : Colors.red[800],
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: LevelCard(
                        level: level,
                        index: index,
                        onLevelSelected: (level) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameScreen(
                                level: level,
                                onScoreUpdate: (additionalScore) {
                                  setState(() {
                                    totalScore += additionalScore;
                                    if (totalScore >= 2000) {
                                      isRedLeagueUnlocked = true;
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelCard extends StatelessWidget {
  final GameLevel level;
  final int index;
  final Function(GameLevel) onLevelSelected;

  const LevelCard({
    Key? key,
    required this.level,
    required this.index,
    required this.onLevelSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => onLevelSelected(level),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                level.color.withOpacity(0.6),
                level.color,
              ],
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: level.color,
                  ),
                ),
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
                    if (level.hasPlatforms)
                      const Text(
                        "С движущимися платформами!",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.play_circle_filled,
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

// Определение класса бонуса (зеленый или красный квадрат)
class Bonus {
  double x;
  double y;
  double size;
  bool
      isGood; // true - зеленый (положительный), false - красный (отрицательный)
  bool isActive;

  Bonus({
    required this.x,
    required this.y,
    required this.size,
    required this.isGood,
    this.isActive = true,
  });
}

// Класс для платформ
class Platform {
  double x;
  double y;
  double width;
  double height;
  double speedX; // Горизонтальная скорость движения
  double minX; // Минимальная позиция X
  double maxX; // Максимальная позиция X

  Platform({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.speedX,
    required this.minX,
    required this.maxX,
  });

  // Обновление позиции платформы
  void update() {
    x += speedX;
    if (x <= minX || x >= maxX) {
      speedX *= -1; // Меняем направление при достижении границы
    }
  }
}

class Obstacle {
  double x;
  double y;
  double size;
  double speedY;

  Obstacle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedY,
  });
}

class GameScreen extends StatefulWidget {
  final GameLevel level;
  final Function(int) onScoreUpdate; // Функция для обновления общего счета

  const GameScreen({
    Key? key,
    required this.level,
    required this.onScoreUpdate,
  }) : super(key: key);

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
  double bonusSize = 25.0;

  // Скорость и направление движения
  double ballSpeedX = 0.0;
  double ballSpeedY = 0.0;
  double jumpForce = -0.04; // Увеличиваем силу прыжка
  double diagonalForce = 0.025; // Увеличиваем силу бокового движения

  // Препятствия и бонусы
  List<Obstacle> obstacles = [];
  List<Bonus> bonuses = [];
  List<Platform> platforms = [];
  int frameCount = 0;
  int bonusSpawnRate = 120; // Частота появления бонусов

  // Статус игры
  bool gameOver = false;
  bool gameWon = false;
  bool levelCompleted = false;
  int score = 0;
  int scoreToAdd = 0; // Счет, который будет добавлен при завершении уровня

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Генерируем случайную позицию для лунки
    final random = Random();
    holeX = random.nextDouble() * 1.5 - 0.75; // От -0.75 до 0.75

    // Добавляем платформы, если уровень их поддерживает
    if (widget.level.hasPlatforms) {
      _initPlatforms();
    }

    // Настраиваем таймер для обновления игры
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _controller.addListener(_updateGame);
  }

  void _initPlatforms() {
    final random = Random();

    // Добавляем несколько платформ
    for (int i = 0; i < 3; i++) {
      double platformX = random.nextDouble() * 1.6 - 0.8;
      double platformY = -0.3 + i * 0.4; // Распределяем по высоте
      double platformWidth = 100.0 + random.nextDouble() * 50.0;

      platforms.add(Platform(
        x: platformX,
        y: platformY,
        width: platformWidth,
        height: 15.0,
        speedX: 0.005 + random.nextDouble() * 0.01,
        minX: -0.8,
        maxX: 0.8,
      ));
    }
  }

  void _updateGame() {
    if (gameOver) return;

    setState(() {
      frameCount++;

      // Создаем новые препятствия с частотой, зависящей от уровня
      if (frameCount % widget.level.obstacleFrequency == 0) {
        _addObstacle();
      }

      // Создаем новые бонусы время от времени
      if (frameCount % bonusSpawnRate == 0) {
        _addBonus();
      }

      // Обновляем позиции платформ
      for (var platform in platforms) {
        platform.update();
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

      // Проверяем столкновения с платформами
      _checkPlatformCollisions();

      // Проверяем столкновения с препятствиями
      _checkObstacleCollisions();

      // Проверяем сбор бонусов
      _checkBonusCollisions();

      // Проверяем попадание в лунку
      final distance = sqrt(pow(ballX - holeX, 2) + pow(ballY - holeY, 2));
      if (distance < 0.1) {
        gameOver = true;
        gameWon = true;
        scoreToAdd += 100; // За попадание в лунку
        score += scoreToAdd;

        // Проверяем, выполнена ли цель уровня
        if (score >= widget.level.targetScore) {
          levelCompleted = true;
        }

        // Обновляем общий счет
        widget.onScoreUpdate(score);

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

    obstacles.add(Obstacle(
      x: obstacleX,
      y: -1.2, // Начинаем над экраном
      size: size,
      speedY: speedY,
    ));
  }

  void _addBonus() {
    final random = Random();

    // Случайная позиция
    double bonusX = random.nextDouble() * 1.6 - 0.8; // От -0.8 до 0.8
    double bonusY = -1.2; // Начинаем над экраном

    // Случайно определяем тип бонуса
    bool isGood = random.nextBool();

    bonuses.add(Bonus(
      x: bonusX,
      y: bonusY,
      size: bonusSize,
      isGood: isGood,
    ));
  }

  void _updateObstacles() {
    // Обновляем позиции препятствий и удаляем те, что вышли за пределы экрана
    obstacles.removeWhere((obstacle) {
      obstacle.y += obstacle.speedY;
      return obstacle.y > 1.5; // Удаляем, если вышел за нижнюю границу
    });

    // Обновляем позиции бонусов
    bonuses.removeWhere((bonus) {
      bonus.y += widget.level.obstacleSpeed;
      return (bonus.y > 1.5 ||
          !bonus.isActive); // Удаляем, если вышел за экран или собран
    });
  }

  void _checkPlatformCollisions() {
    for (var platform in platforms) {
      // Проверяем, находится ли шарик над платформой и падает ли он
      bool isAbovePlatform = ballX >=
              platform.x -
                  platform.width / MediaQuery.of(context).size.width / 2 &&
          ballX <=
              platform.x +
                  platform.width / MediaQuery.of(context).size.width / 2;

      double ballBottom =
          ballY + ballSize / MediaQuery.of(context).size.height / 3 / 2;
      double platformTop = platform.y -
          platform.height / MediaQuery.of(context).size.height / 3 / 2;

      double prevBallBottom = ballBottom - ballSpeedY;

      if (isAbovePlatform &&
          ballBottom >= platformTop &&
          prevBallBottom < platformTop &&
          ballSpeedY > 0) {
        // Шарик приземлился на платформу
        ballY = platform.y -
            (ballSize + platform.height) /
                MediaQuery.of(context).size.height /
                3 /
                2;
        ballSpeedY = 0;

        // Платформа "несет" шарик
        ballX += platform.speedX;
      }
    }
  }

  void _checkObstacleCollisions() {
    for (var obstacle in obstacles) {
      final distance =
          sqrt(pow(ballX - obstacle.x, 2) + pow(ballY - obstacle.y, 2));
      double collisionDistance =
          (ballSize + obstacle.size) / 2 / MediaQuery.of(context).size.width;

      if (distance < collisionDistance) {
        // Отскок от препятствия
        double angle = atan2(ballY - obstacle.y, ballX - obstacle.x);

        ballSpeedX = cos(angle) * 0.05;
        ballSpeedY = sin(angle) * 0.05;

        // Увеличиваем счет за столкновение
        score += 5;
      }
    }
  }

  void _checkBonusCollisions() {
    for (var bonus in bonuses) {
      if (!bonus.isActive) continue;

      final distance = sqrt(pow(ballX - bonus.x, 2) + pow(ballY - bonus.y, 2));
      double collisionDistance =
          (ballSize + bonus.size) / 2 / MediaQuery.of(context).size.width;

      if (distance < collisionDistance) {
        bonus.isActive = false; // Деактивируем бонус

        if (bonus.isGood) {
          // Зеленый бонус (+25 очков)
          scoreToAdd += 25;
          score += 25;
        } else {
          // Красный бонус
          if (widget.level.league == League.Green) {
            // В зеленой лиге красные бонусы отнимают 50 очков
            scoreToAdd -= 50;
            score -= 50;
            if (score < 0) score = 0;
          } else {
            // В красной лиге красные бонусы убивают
            _gameOver(false);
            return;
          }
        }
      }
    }
  }

  void _jump() {
    if (_isOnGround() || _isOnPlatform()) {
      setState(() {
        ballSpeedY = jumpForce;
      });
    }
  }

  void _moveLeft() {
    setState(() {
      ballSpeedX -= diagonalForce;
      // Ограничиваем максимальную скорость
      if (ballSpeedX < -0.05) ballSpeedX = -0.05;
    });
  }

  void _moveRight() {
    setState(() {
      ballSpeedX += diagonalForce;
      // Ограничиваем максимальную скорость
      if (ballSpeedX > 0.05) ballSpeedX = 0.05;
    });
  }

  bool _isOnGround() {
    return ballY >= 0.95;
  }

  bool _isOnPlatform() {
    for (var platform in platforms) {
      bool isAbovePlatform = ballX >=
              platform.x -
                  platform.width / MediaQuery.of(context).size.width / 2 &&
          ballX <=
              platform.x +
                  platform.width / MediaQuery.of(context).size.width / 2;

      double ballBottom =
          ballY + ballSize / MediaQuery.of(context).size.height / 3 / 2;
      double platformTop = platform.y -
          platform.height / MediaQuery.of(context).size.height / 3 / 2;

      if (isAbovePlatform &&
          (platformTop - ballBottom).abs() < 0.01 &&
          ballSpeedY >= 0) {
        return true;
      }
    }
    return false;
  }

  void _gameOver(bool success) {
    setState(() {
      gameOver = true;
      gameWon = success;

      if (success) {
        // За завершение уровня добавляем 100 очков
        scoreToAdd += 100;
        score += 100;

        // Проверяем, выполнена ли цель уровня
        if (score >= widget.level.targetScore) {
          levelCompleted = true;
        }

        // Обновляем общий счет
        widget.onScoreUpdate(score);
      }

      _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.level.name),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: _jump,
        onPanUpdate: (details) {
          if (details.delta.dx < 0) {
            _moveLeft();
          } else if (details.delta.dx > 0) {
            _moveRight();
          }
        },
        child: CustomPaint(
          painter: GamePainter(
            ballX: ballX,
            ballY: ballY,
            ballSize: ballSize,
            holeX: holeX,
            holeY: holeY,
            holeSize: holeSize,
            obstacles: obstacles,
            bonuses: bonuses,
            platforms: platforms,
          ),
          child: Container(),
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final double ballSize;
  final double holeX;
  final double holeY;
  final double holeSize;
  final List<Obstacle> obstacles;
  final List<Bonus> bonuses;
  final List<Platform> platforms;

  GamePainter({
    required this.ballX,
    required this.ballY,
    required this.ballSize,
    required this.holeX,
    required this.holeY,
    required this.holeSize,
    required this.obstacles,
    required this.bonuses,
    required this.platforms,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Рисуем лунку
    paint.color = Colors.black;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(holeX * size.width / 2 + size.width / 2,
            holeY * size.height / 2 + size.height / 2),
        width: holeSize,
        height: holeSize,
      ),
      paint,
    );

    // Рисуем шарик
    paint.color = Colors.blue;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(ballX * size.width / 2 + size.width / 2,
            ballY * size.height / 2 + size.height / 2),
        width: ballSize,
        height: ballSize,
      ),
      paint,
    );

    // Рисуем препятствия
    paint.color = Colors.red;
    for (var obstacle in obstacles) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(obstacle.x * size.width / 2 + size.width / 2,
              obstacle.y * size.height / 2 + size.height / 2),
          width: obstacle.size,
          height: obstacle.size,
        ),
        paint,
      );
    }

    // Рисуем бонусы
    for (var bonus in bonuses) {
      paint.color = bonus.isGood ? Colors.green : Colors.red;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(bonus.x * size.width / 2 + size.width / 2,
              bonus.y * size.height / 2 + size.height / 2),
          width: bonus.size,
          height: bonus.size,
        ),
        paint,
      );
    }

    // Рисуем платформы
    paint.color = Colors.brown;
    for (var platform in platforms) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(platform.x * size.width / 2 + size.width / 2,
              platform.y * size.height / 2 + size.height / 2),
          width: platform.width,
          height: platform.height,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
