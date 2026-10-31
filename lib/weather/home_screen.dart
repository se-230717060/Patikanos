import 'package:flutter/material.dart';

import 'weather_model.dart';
import 'weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = WeatherService();
  String _activity = 'bike';
  late Future<WeatherScore> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _service.getScore(
      lat: WeatherService.muglaLat,
      lon: WeatherService.muglaLon,
      activity: _activity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bugün · Muğla')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'bike', label: Text('Bisiklet'), icon: Icon(Icons.directions_bike)),
                ButtonSegment(value: 'walk', label: Text('Yürüyüş'), icon: Icon(Icons.directions_walk)),
              ],
              selected: {_activity},
              onSelectionChanged: (s) => setState(() {
                _activity = s.first;
                _load();
              }),
            ),
          ),
          Expanded(
            child: FutureBuilder<WeatherScore>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _ErrorView(onRetry: () => setState(_load));
                }
                return _ScoreView(data: snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreView extends StatelessWidget {
  final WeatherScore data;
  const _ScoreView({required this.data});

  @override
  Widget build(BuildContext context) {
    final score = data.nowScore;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text('Şu an (${data.nowTime ?? '-'})'),
                const SizedBox(height: 8),
                Text(
                  score == null ? '-' : '$score/10',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: score == null ? null : scoreColor(score),
                  ),
                ),
                if (score != null) Text(scoreLabel(score)),
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Bugünün en iyi zamanı'),
            subtitle: Text(data.bestStart == null
                ? 'Bugün uygun saat yok'
                : '${data.bestStart} – ${data.bestEnd}'),
          ),
        ),
        for (final warning in data.warnings)
          Card(
            child: ListTile(
              leading: const Icon(Icons.warning_amber, color: Colors.orange),
              title: Text(warning),
            ),
          ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 48),
          const SizedBox(height: 8),
          const Text('Hava durumu alınamadı'),
          const SizedBox(height: 8),
          FilledButton(onPressed: onRetry, child: const Text('Tekrar dene')),
        ],
      ),
    );
  }
}
