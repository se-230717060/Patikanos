import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE9E4DF),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rotalar',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Öne çıkan rotalar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2F2F2F),
              ),
            ),
            const SizedBox(height: 14),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(label: 'Gün doğumu'),
                _FilterChip(label: 'Sahil'),
                _FilterChip(label: 'Kırsal'),
                _FilterChip(label: 'Zor'),
              ],
            ),
            const SizedBox(height: 18),
            _RouteCard(
              title: 'Muğla Sahil Yürüyüş',
              subtitle: '4.5 km • 32 dk',
              color: const Color(0xFF1D7A68),
            ),
            const SizedBox(height: 12),
            _RouteCard(
              title: 'Büyük Orman Bisiklet',
              subtitle: '9.1 km • 54 dk',
              color: const Color(0xFFE7A94A),
            ),
            const SizedBox(height: 12),
            _RouteCard(
              title: 'Mavi Körfez',
              subtitle: '6.3 km • 41 dk',
              color: const Color(0xFF2C7BEA),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4F2),
        border: Border.all(color: const Color(0xFF2B2B2B), width: 1.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF232323),
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4F2),
        border: Border.all(color: const Color(0xFF2B2B2B), width: 1.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B4B4B),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Color(0xFF1D1D1D)),
        ],
      ),
    );
  }
}
