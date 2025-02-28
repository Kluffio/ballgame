import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_level.dart';
import '../models/obstacle.dart';
import '../models/user_progress.dart';
import '../game/game-physics.dart';
import '../game/obstacle-manager.dart';
import '../game/collision-detector.dart';
import '../widgets/game_controls.dart';

class GameScreen extends StatefulWidget {
  final GameLevel level;

  const GameScreen({Key? key, required this.level}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Позиция мяча и скорость
  double ballX = 0.0;
  double ballY = 0.0;
  double ballSpeedX = 0.0;
  double ballSpeedY = 0.0;
  
  // Размер мяча
  final double ballSize = 30.0;
  
  // Позиция лунки
  double holeX = 0.0;
  double holeY = 0.8;
  
  // Игровые параметры
  int score = 0;
  int levelScore = 0;
  bool isGameOver = false;
  bool isLevelComplete = false;
  
  // Менеджеры игровой логики
  late GamePhysics gamePhysics;
  late ObstacleManager obstacleManager;
  late CollisionDetector collisionDetector;
  
  // Контроллер анимации для мяча при завершении уровня
  late AnimationController _winAnimationController;
  late Animation<double> _ballScaleAnimation;
  
  // Игровой таймер и его длительность
  Timer? gameTimer;
  int remainingTime = 60; // 60 секунд на уровень
  
  // Размер экрана
  Size screenSize = const Size(100, 100);
  
  @override
  void initState() {
    super.initState();
    
    // Инициализация физики игры
    gamePhysics = GamePhysics(gravity: widget.level.gravity);
    
    // Инициализация менеджера препятствий
    obstacleManager = ObstacleManager(level: widget.level);
    
    // Инициализация контроллера анимации победы
    _winAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _ballScaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _winAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Слушатель анимации для перехода к экрану результатов
    _winAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showLevelCompleteDialog();
      }
    });
    
    // Запуск таймера
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          _gameOver();
        }
      });
    });
    
    // Генерация новой случайной позиции для лунки
    _generateNewHolePosition();
  }
  
  @override
  void dispose() {
    _winAnimationController.dispose();
    gameTimer?.cancel();
    super.dispose();
  }
  
  void _generateNewHolePosition() {
    final random = Random();
    holeX = random.nextDouble() * 1.6 - 0.8; // от -0.8 до 0.8
    holeY = 0.8;
  }
  
  void _gameOver() {
    if (isGameOver) return;
    
    setState(() {
      isGameOver = true;
    });
    
    gameTimer?.cancel();
    
    _showGameOverDialog();
  }
  
  void _levelComplete() {
    if (isLevelComplete) return;
    
    setState(() {
      isLevelComplete = true;
    });
    
    gameTimer?.cancel();
    
    // Добавляем очки за оставшееся время
    int timeBonus = remainingTime * 5;
    setState(() {
      score += timeBonus;
      levelScore += timeBonus;
    });
    
    // Запускаем анимацию
    _winAnimationController.forward();
  }
  
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Игра окончена!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Вы набрали: $levelScore очков'),
            const SizedBox(height: 10),
            Text('Цель: ${widget.level.targetScore} очков'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Возврат в меню
            },
            child: const Text('В меню'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
  
  void _showLevelCompleteDialog() {
    bool isTargetReached = levelScore >= widget.level.targetScore;
    
    // Обновляем прогресс пользователя
    if (isTargetReached) {
      int currentLevelIndex = -1;
      for (int i = 0; i < LevelsData.levels.length; i++) {
        if (LevelsData.levels[i].name == widget.level.name) {
          currentLevelIndex = i;
          break;
        }
      }
      
      if (currentLevelIndex >= 0) {
        UserProgress.unlockNextLevel(currentLevelIndex);
      }
      
      UserProgress.addScore(levelScore);
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isTargetReached ? 'Уровень пройден!' : 'Недостаточно очков'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Вы набрали: $levelScore очков'),
            const SizedBox(height: 10),
            Text('Цель: ${widget.level.targetScore} очков'),
            const SizedBox(height: 20),
            if (isTargetReached)
              const Text(
                'Поздравляем! Вы открыли следующий уровень!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (!isTargetReached)
              const Text(
                'Попробуйте еще раз, чтобы пройти уровень',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Возврат в меню
            },
            child: const Text('В меню'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
  
  void _restartGame() {
    setState(() {
      ballX = 0.0;
      ballY = 0.0;
      ballSpeedX = 0.0;
      ballSpeedY = 0.0;
      score = 0;
      levelScore = 0;
      isGameOver = false;
      isLevelComplete = false;
      remainingTime = 60;
    });
    
    obstacleManager.clearObstacles();
    _generateNewHolePosition();
    
    // Сброс контроллера анимации
    _winAnimationController.reset();
    
    // Перезапуск таймера
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          _gameOver();
        }
      });
    });
  }
  
  void _jumpLeft() {
    if (!isGameOver && !isLevelComplete) {
      gamePhysics.jumpLeft(
        ballSpeedX: ballSpeedX,
        ballSpeedY: ballSpeedY,
        setNewVelocity: (newSpeedX, newSpeedY) {
          setState(() {
            ballSpeedX = newSpeedX;
            ballSpeedY = newSpeedY;
          });
        },
      );
    }
  }
  
  void _jumpRight() {
    if (!isGameOver && !isLevelComplete) {
      gamePhysics.jumpRight(
        ballSpeedX: ballSpeedX,
        ballSpeedY: ballSpeedY,
        setNewVelocity: (newSpeedX, newSpeedY) {
          setState(() {
            ballSpeedX = newSpeedX;
            ballSpeedY = newSpeedY;
          });
        },
      );
    }
  }
  
  void _returnToMenu(BuildContext context) {
    Navigator.of(context).pop();
  }
  
  void _updateGame() {
    if (isGameOver || isLevelComplete) return;
    
    // Обновляем физику мяча
    gamePhysics.updateBallPhysics(
      ballX: ballX,
      ballY: ballY,
      ballSpeedX: ballSpeedX,
      ballSpeedY: ballSpeedY,
      setNewPosition: (newX, newY, newSpeedX, newSpeedY) {
        setState(() {
          ballX = newX;
          ballY = newY;
          ballSpeedX = newSpeedX;
          ballSpeedY = newSpeedY;
        });
      },
    );
    
    // Обновляем препятствия
    obstacleManager.update();
    
    // Инициализация детектора коллизий (нужно делать здесь, чтобы получить актуальный размер экрана)
    collisionDetector = CollisionDetector(
      level: widget.level,
      screenSize: screenSize,
      ballSize: ballSize,
    );
    
    // Проверяем столкновения с препятствиями
    final collisionResult = collisionDetector.checkObstacleCollisions(
      ballX,
      ballY,
      obstacleManager.getObstacles(),
    );
    
    if (collisionResult.hasCollision) {
      if (collisionResult.isBonus) {
        // Зеленый квадрат (бонус)
        setState(() {
          score += 50;
          levelScore += 50;
        });
        
        // Удаляем бонус
        obstacleManager.obstacles.remove(collisionResult.obstacle);
      } else {
        // Красный квадрат (штраф или смерть)
        if (widget.level.league.redObstaclesKill) {
          // В красной лиге красные квадраты убивают
          _gameOver();
        } else {
          // В зеленой лиге красные квадраты отнимают очки
          setState(() {
            score -= widget.level.league.redObstaclesPenalty;
            levelScore -= widget.level.league.redObstaclesPenalty;
            if (score < 0) score = 0;
            if (levelScore < 0) levelScore = 0;
          });
          
          // Отбрасываем мяч
          if (collisionResult.updateVelocity != null) {
            collisionResult.updateVelocity!((newSpeedX, newSpeedY) {
              setState(() {
                ballSpeedX = newSpeedX;
                ballSpeedY = newSpeedY;
              });
            });
          }
        }
      }
    }
    
    // Проверяем попадание в лунку
    if (gamePhysics.checkHoleCollision(ballX, ballY, holeX, holeY)) {
      setState(() {
        score += 100;
        levelScore += 100;
      });
      
      _generateNewHolePosition();
      
      // Проверяем достижение цели уровня
      if (levelScore >= widget.level.targetScore) {
        _levelComplete();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.level.color.withOpacity(0.3),
                        widget.level.color,
                      ],
                    ),
                  ),
                ),
                
                // Игровое поле
                GestureDetector(
                  onTap: () {
                    _updateGame();
                  },
                  child: AnimatedBuilder(
                    animation: _winAnimationController,
                    builder: (context, child) {
                      // Обновляем игру на каждом кадре
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _updateGame();
                      });
                      
                      return CustomPaint(
                        painter: GamePainter(
                          ballX: ballX,
                          ballY: ballY,
                          ballSize: ballSize * _ballScaleAnimation.value,
                          holeX: holeX,
                          holeY: holeY,
                          obstacles: obstacleManager.getObstacles(),
                        ),
                        size: Size.infinite,
                      );
                    },
                  ),
                ),
                
                // Игровая информация
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Уровень и счет
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.level.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Счет: $levelScore / ${widget.level.targetScore}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        // Таймер
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$remainingTime',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Игровые кнопки управления
          GameControls(
            jumpLeft: _jumpLeft,
            jumpRight: _jumpRight,
            returnToMenu: _returnToMenu,
          ),
        ],
      ),
    );
  }
}

// Класс для отрисовки игрового поля
class GamePainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final double ballSize;
  final double holeX;
  final double holeY;
  final List<Obstacle> obstacles;
  
  GamePainter({
    required this.ballX,
    required this.ballY,
    required this.ballSize,
    required this.holeX,
    required this.holeY,
    required this.obstacles,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Конвертируем нормализованные координаты в координаты экрана
    double screenBallX = (ballX + 1) * size.width / 2;
    double screenBallY = (ballY + 1) * size.height / 2;
    double screenHoleX = (holeX + 1) * size.width / 2;
    double screenHoleY = (holeY + 1) * size.height / 2;
    
    // Рисуем лунку (черный круг)
    final holePaint = Paint()..color = Colors.black;
    canvas.drawCircle(
      Offset(screenHoleX, screenHoleY),
      20,
      holePaint,
    );
    
    // Рисуем шарик (белый круг)
    final ballPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(screenBallX, screenBallY),
      ballSize / 2,
      ballPaint,
    );
    
    // Рисуем препятствия
    for (var obstacle in obstacles) {
      double screenObstacleX = (obstacle.x + 1) * size.width / 2;
      double screenObstacleY = (obstacle.y + 1) * size.height / 2;
      
      final obstaclePaint = Paint()..color = obstacle.color;
      
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(screenObstacleX, screenObstacleY),
          width: obstacle.size,
          height: obstacle.size,
        ),
        obstaclePaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(GamePainter oldDelegate) {
    return oldDelegate.ballX != ballX ||
        oldDelegate.ballY != ballY ||
        oldDelegate.holeX != holeX ||
        oldDelegate.holeY != holeY ||
        oldDelegate.obstacles != obstacles;
  }
}

// Костыль для получения доступа к классу LevelsData
class LevelsData {
  static final List<GameLevel> levels = [];
}
