import 'dart:math';
import 'package:flutter/material.dart';
import '../models/obstacle.dart';
import '../models/game_level.dart';

class ObstacleManager {
  final GameLevel level;
  final double obstacleBaseSize = 35.0;
  List<Obstacle> obstacles = [];
  int frameCount = 0;
  
  ObstacleManager({required this.level});
  
  void update() {
    frameCount++;
    
    // Создаем новые препятствия с частотой, зависящей от уровня
    if (frameCount % level.obstacleFrequency == 0) {
      addObstacle();
    }
    
    // Обновляем позиции препятствий
    updateObstacles();
  }
  
  void addObstacle() {
    final random = Random();
    
    // Случайная позиция по X
    double obstacleX = random.nextDouble() * 1.8 - 0.9; // От -0.9 до 0.9
    
    // Случайный размер
    double size = obstacleBaseSize + random.nextDouble() * 15;
    
    // Скорость зависит от уровня
    double speedY = level.obstacleSpeed + random.nextDouble() * 0.01;
    
    // Случайно определяем тип препятствия (бонус/штраф)
    bool isBonus = random.nextDouble() > 0.5;
    Color color = isBonus ? Colors.green : Colors.red;
    
    // Определяем, будет ли это движущаяся платформа
    bool isMovingPlatform = level.hasMovingPlatforms && random.nextDouble() > 0.7;
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
  
  void updateObstacles() {
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
  
  List<Obstacle> getObstacles() {
    return obstacles;
  }
  
  void clearObstacles() {
    obstacles.clear();
  }
}
