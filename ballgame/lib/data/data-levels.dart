import 'package:flutter/material.dart';
import '../models/league.dart';
import '../models/game_level.dart';

class LevelsData {
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
}
