import 'package:flutter/material.dart';

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
