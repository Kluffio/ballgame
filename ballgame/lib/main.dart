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

class GameLevel {
  final String name;
  final String description;
  final Color color;
  final int obstacleFrequency;
  final double gravity;
  final double obstacleSpeed;
  final int targetScore;

  GameLevel({
    required this.name,
    required this.description,
    required this.color,
    required this.obstacleFrequency,
    required this.gravity,
    required this.obstacleSpeed,
    required this.targetScore,
  });
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  static List<GameLevel> levels = [
    GameLevel(
      name: "Уровень 1",
      description: "Легкий старт для новичков",
      color: Colors.green,
      obstacleFrequency: 100,
      gravity: 0.003,
      obstacleSpeed: 0.005,
      targetScore: 150,
    ),
    GameLevel(
      name: "Уровень 2",
      description: "Немного быстрее",
      color: Colors.lightBlue,
      obstacleFrequency: 80,
      gravity: 0.004,
      obstacleSpeed: 0.008,
      targetScore: 250,
    ),
    GameLevel(
      name: "Уровень 3",
      description: "Будь осторожен!",
      color: Colors.amber,
      obstacleFrequency: 60,
      gravity: 0.005,
      obstacleSpeed: 0.01,
      targetScore: 350,
    ),
    GameLevel(
      name: "Уровень 4",
      description: "Для опытных игроков",
      color: Colors.orange,
      obstacleFrequency: 40,
      gravity: 0.006,
      obstacleSpeed: 0.015,
      targetScore: 450,
    ),
    GameLevel(
      name: "Уровень 5",
      description: "Высший уровень сложности!",
      color: Colors.red,
      obstacleFrequency: 30,
      gravity: 0.007,
      obstacleSpeed: 0.02,
      targetScore: 600,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            colors: [Colors.blue[100]!, Colors.blue[300]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                "Выберите уровень",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
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

  const LevelCard({
    Key? key,
    required this.level,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(level: level),
            ),
          );
        },
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
  double jumpForce = -0.03;
  double diagonalForce = 0.02;
  
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
        score += 100;
        
        // Проверяем, выполнена ли цель уровня
        if (score >= widget.level.targetScore) {
          levelCompleted = true;
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
    
    obstacles.add(Obstacle(
      x: obstacleX,
      y: -1.2, // Начинаем над экраном
      size: size,
      speedY: speedY,
    ));
  }
  
  void _updateObstacles() {
    // Обновляем позиции препятствий и удаляем те, что вышли за пределы экрана
    obstacles.removeWhere((obstacle) {
      obstacle.y += obstacle.speedY;
      return obstacle.y > 1.5; // Удаляем, если вышел за нижнюю границу
    });
  }
  
  void _checkObstacleCollisions() {
    for (var obstacle in obstacles) {
      final distance = sqrt(pow(ballX - obstacle.x, 2) + pow(ballY - obstacle.y, 2));
      double collisionDistance = (ballSize + obstacle.size) / 2 / MediaQuery.of(context).size.width;
      
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
    if (currentIndex < MainMenu.levels.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(level: MainMenu.levels[currentIndex + 1]),
        ),
      );
    } else {
      // Это был последний уровень, возвращаемся в меню
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainMenu(),
        ),
      );
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
            flex: 4,
            child: Container(
              color: Colors.lightBlue[100],
              child: Center(
                child: Stack(
                  children: [
                    // Лунка
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 + holeX * MediaQuery.of(context).size.width / 2 - holeSize / 2,
                      top: MediaQuery.of(context).size.height / 3 + holeY * MediaQuery.of(context).size.height / 3 - holeSize / 2,
                      child: Container(
                        width: holeSize,
                        height: holeSize,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    
                    // Препятствия
                    ...obstacles.map((obstacle) => Positioned(
                      left: MediaQuery.of(context).size.width / 2 + obstacle.x * MediaQuery.of(context).size.width / 2 - obstacle.size / 2,
                      top: MediaQuery.of(context).size.height / 3 + obstacle.y * MediaQuery.of(context).size.height / 3 - obstacle.size / 2,
                      child: Container(
                        width: obstacle.size,
                        height: obstacle.size,
                        decoration: BoxDecoration(
                          color: widget.level.color,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    )),
                    
                    // Шарик
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 + ballX * MediaQuery.of(context).size.width / 2 - ballSize / 2,
                      top: MediaQuery.of(context).size.height / 3 + ballY * MediaQuery.of(context).size.height / 3 - ballSize / 2,
                      child: Container(
                        width: ballSize,
                        height: ballSize,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Сообщение о победе
                    if (gameWon)
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: levelCompleted ? Colors.green[100] : Colors.amber[100],
                            borderRadius: BorderRadius.circular(15),
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
                              Text(
                                levelCompleted ? 'Уровень пройден!' : 'Попробуй еще раз!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: levelCompleted ? Colors.green[800] : Colors.amber[800],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Ваш счет: $score / ${widget.level.targetScore}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: levelCompleted 
                                      ? () => _goToNextLevel(context)
                                      : _resetGame,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: levelCompleted ? Colors.green : Colors.amber,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    child: Text(
                                      levelCompleted ? 'Следующий уровень' : 'Попробовать снова',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () => _returnToMenu(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    child: const Text(
                                      'В меню',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Увеличенная кнопка влево
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _jumpLeft,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: widget.level.color,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  // Увеличенная кнопка вправо
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _jumpRight,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: widget.level.color,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
