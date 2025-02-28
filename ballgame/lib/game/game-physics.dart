import 'dart:math';

class GamePhysics {
  final double gravity;
  
  // Константы движения
  final double jumpForce = -0.04;
  final double diagonalForce = 0.025;
  
  GamePhysics({required this.gravity});
  
  // Обновление физики шарика
  void updateBallPhysics({
    required double ballX,
    required double ballY,
    required double ballSpeedX,
    required double ballSpeedY,
    required Function(double, double, double, double) setNewPosition,
  }) {
    // Применяем гравитацию
    ballSpeedY += gravity;
    
    // Обновляем позицию шарика
    double newX = ballX + ballSpeedX;
    double newY = ballY + ballSpeedY;
    
    // Проверяем столкновения со стенками
    if (newX < -1.0) {
      newX = -1.0;
      ballSpeedX *= -0.7; // Отскок с затуханием
    } else if (newX > 1.0) {
      newX = 1.0;
      ballSpeedX *= -0.7;
    }
    
    // Проверка на дно экрана
    if (newY > 1.0) {
      newY = 1.0;
      ballSpeedY *= -0.7;
      // Трение о поверхность
      ballSpeedX *= 0.95;
    }
    
    // Замедление движения для реалистичности
    ballSpeedX *= 0.99;
    ballSpeedY *= 0.99;
    
    // Обновляем позицию
    setNewPosition(newX, newY, ballSpeedX, ballSpeedY);
  }
  
  // Прыжок влево
  void jumpLeft({
    required double ballSpeedX,
    required double ballSpeedY,
    required Function(double, double) setNewVelocity,
  }) {
    setNewVelocity(-diagonalForce, jumpForce);
  }
  
  // Прыжок вправо
  void jumpRight({
    required double ballSpeedX,
    required double ballSpeedY,
    required Function(double, double) setNewVelocity,
  }) {
    setNewVelocity(diagonalForce, jumpForce);
  }
  
  // Проверка попадания в лунку
  bool checkHoleCollision(double ballX, double ballY, double holeX, double holeY) {
    final distance = sqrt(pow(ballX - holeX, 2) + pow(ballY - holeY, 2));
    return distance < 0.1;
  }
}
