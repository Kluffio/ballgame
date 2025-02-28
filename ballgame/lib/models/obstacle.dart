import 'package:flutter/material.dart';

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
