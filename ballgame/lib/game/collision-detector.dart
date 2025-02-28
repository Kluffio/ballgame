import 'dart:math';
import 'package:flutter/material.dart';
import '../models/obstacle.dart';
import '../models/game_level.dart';

class CollisionResult {
  final bool hasCollision;
  final bool isBonus;
  final Obstacle? obstacle;
  final Function? updateVelocity;

  CollisionResult({
    required this.hasCollision,
    required this.isBonus,
    this.obstacle,
    this.updateVelocity,
  });
}

class CollisionDetector {
  final GameLevel level;
  final Size screenSize;
  final double ballSize;
  
  CollisionDetector({
    required this.level,
    required this.screenSize,
    required this.ballSize,
  });
  
  CollisionResult checkObstacleCollisions(
    double ballX,
    double ballY,
    List<Obstacle> obstacles,
  ) {
    for (var obstacle in obstacles) {
      final distance = sqrt(pow(ballX - obstacle.x, 2) + pow(ballY - obstacle.y, 2));
      double collisionDistance = (ballSize + obstacle.size) / 2 / screenSize.width;
      
      if (distance < collisionDistance) {
        if (obstacle.isBonus) {
          // Зеленый квадрат - бонус
          return CollisionResult(
            hasCollision: true,
            isBonus: true,
            obstacle: obstacle,
          );
        } else {
          // Красный квадрат - штраф или смерть
          if (level.league.redObstaclesKill) {
            // В красной лиге красные квадраты убивают
            return CollisionResult(
              hasCollision: true,
              isBonus: false,
              obstacle: obstacle,
              updateVelocity: null,
            );
          } else {
            // В зеленой лиге красные квадраты отнимают очки и отбрасывают
            double angle = atan2(ballY - obstacle.y, ballX - obstacle.x);
            
            return CollisionResult(
              hasCollision: true,
              isBonus: false,
              obstacle: obstacle,
              updateVelocity: (Function setVelocity) {
                setVelocity(cos(angle) * 0.05, sin(angle) * 0.05);
              },
            );
          }
        }
      }
    }
    
    return CollisionResult(hasCollision: false, isBonus: false);
  }
}
