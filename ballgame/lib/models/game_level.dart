import 'package:flutter/material.dart';
import 'league.dart';

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
