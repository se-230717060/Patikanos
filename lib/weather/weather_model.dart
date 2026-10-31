import 'package:flutter/material.dart';

class HourlyWeather {
  final String time;
  final int score;
  final double feelsLike;
  final double wind;
  final int rainProb;
  final double uv;

  HourlyWeather({
    required this.time,
    required this.score,
    required this.feelsLike,
    required this.wind,
    required this.rainProb,
    required this.uv,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) => HourlyWeather(
        time: json['time'] as String,
        score: (json['score'] as num).toInt(),
        feelsLike: (json['feels_like'] as num).toDouble(),
        wind: (json['wind'] as num).toDouble(),
        rainProb: (json['rain_prob'] as num? ?? 0).toInt(),
        uv: (json['uv'] as num).toDouble(),
      );
}

class WeatherScore {
  final String activity;
  final String? nowTime;
  final int? nowScore;
  final String? bestStart;
  final String? bestEnd;
  final List<String> warnings;
  final List<HourlyWeather> hourly;

  WeatherScore({
    required this.activity,
    this.nowTime,
    this.nowScore,
    this.bestStart,
    this.bestEnd,
    required this.warnings,
    required this.hourly,
  });

  factory WeatherScore.fromJson(Map<String, dynamic> json) {
    final now = json['now'] as Map<String, dynamic>?;
    final best = json['best_window'] as Map<String, dynamic>?;
    return WeatherScore(
      activity: json['activity'] as String,
      nowTime: now?['time'] as String?,
      nowScore: (now?['score'] as num?)?.toInt(),
      bestStart: best?['start'] as String?,
      bestEnd: best?['end'] as String?,
      warnings: (json['warnings'] as List).cast<String>(),
      hourly: (json['hourly'] as List)
          .map((h) => HourlyWeather.fromJson(h as Map<String, dynamic>))
          .toList(),
    );
  }
}

Color scoreColor(int score) =>
    score >= 8 ? Colors.green : (score >= 5 ? Colors.orange : Colors.red);

String scoreLabel(int score) =>
    score >= 8 ? 'Harika' : (score >= 5 ? 'İdare eder' : 'Önerilmez');