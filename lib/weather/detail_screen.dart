import 'package:flutter/material.dart';

import 'weather_model.dart';

class DetailScreen extends StatelessWidget {
  final WeatherScore data;
  const DetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final hours = data.hourly.where((h) {
      final hour = int.parse(h.time.substring(0, 2));
      return hour >= 6 && hour < 21;
    }).toList();
    final title = data.activity == 'bike' ? 'Bisiklet' : 'Yürüyüş';

    return Scaffold(
      appBar: AppBar(title: Text('Saatlik detay · $title')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: hours.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) =>
            _HourRow(hour: hours[i], isNow: hours[i].time == data.nowTime),
      ),
    );
  }
}

class _HourRow extends StatelessWidget {
  final HourlyWeather hour;
  final bool isNow;
  const _HourRow({required this.hour, required this.isNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isNow ? Colors.blue.withValues(alpha: 0.08) : null,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 56,
                child: Text(
                  hour.time,
                  style: TextStyle(fontWeight: isNow ? FontWeight.bold : FontWeight.normal),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: hour.score / 10,
                    minHeight: 10,
                    color: scoreColor(hour.score),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 28,
                child: Text(
                  '${hour.score}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Text(
              '🌡 ${hour.feelsLike.toStringAsFixed(0)}°C   '
              '💨 ${hour.wind.toStringAsFixed(0)} km/s   '
              '☔ %${hour.rainProb}   '
              '☀️ UV ${hour.uv.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}