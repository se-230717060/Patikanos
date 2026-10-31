import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'weather_model.dart';
import 'weather_service.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static const _details = NotificationDetails(
    iOS: DarwinNotificationDetails(),
    android: AndroidNotificationDetails('weather', 'Hava önerileri'),
  );

  static Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
    await _plugin.initialize(
      settings: const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _ready = true;
  }

  static Future<void> _schedule(int id, tz.TZDateTime at, String title, String body) {
    return _plugin.zonedSchedule(
      id: id,
      scheduledDate: at,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: title,
      body: body,
    );
  }

  /// Bugünün kalan gündüz saatleri için saat başı bildirim + 21:00'de yarın önerisi.
  static Future<void> scheduleAll(String activity) async {
    await init();
    await _plugin.cancelAll();

    final service = WeatherService();
    final today = await service.getScore(
        lat: WeatherService.muglaLat, lon: WeatherService.muglaLon, activity: activity);
    final tomorrow = await service.getScore(
        lat: WeatherService.muglaLat, lon: WeatherService.muglaLon, activity: activity, day: 'tomorrow');

    final emoji = activity == 'bike' ? '🚲' : '🚶';
    final name = activity == 'bike' ? 'Bisiklet' : 'Yürüyüş';
    final now = tz.TZDateTime.now(tz.local);

    for (final h in today.hourly) {
      final hour = int.parse(h.time.substring(0, 2));
      if (hour < 6 || hour >= 21) continue;
      final at = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
      if (!at.isAfter(now)) continue;
      await _schedule(hour, at, '$emoji ${h.time} · $name ${h.score}/10', _hourMessage(h));
    }

    final evening = tz.TZDateTime(tz.local, now.year, now.month, now.day, 21);
    if (evening.isAfter(now)) {
      final body = tomorrow.bestStart == null
          ? 'Yarın ${name.toLowerCase()} için uygun saat görünmüyor.'
          : 'Yarın ${tomorrow.bestStart}–${tomorrow.bestEnd} ${name.toLowerCase()} için ideal.';
      await _schedule(100, evening, '$emoji Yarın için öneri', body);
    }
  }

  static String _hourMessage(HourlyWeather h) {
    if (h.score >= 8) return 'Çıkmak için harika bir saat.';
    if (h.rainProb >= 30) return 'Yağmur ihtimali %${h.rainProb}.';
    if (h.wind >= 20) return 'Rüzgâr ${h.wind.toStringAsFixed(0)} km/s.';
    if (h.feelsLike <= 12) return 'Hava serin (${h.feelsLike.toStringAsFixed(0)}°C).';
    if (h.uv >= 6) return 'UV yüksek, gölge tercih et.';
    return 'Şartlar idare eder.';
  }

  /// Deneme: 5 saniye sonra bir bildirim.
  static Future<void> testIn5Seconds() async {
    await init();
    await _schedule(999, tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        '🔔 Patikanos', 'Bildirimler çalışıyor!');
  }
}