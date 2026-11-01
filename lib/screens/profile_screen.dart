import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              'Profil ve Ayarlar',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF3F1EE),
                  border: Border.all(color: const Color(0xFF2B2B2B), width: 1.2),
                ),
                child: const Icon(
                  Icons.person,
                  size: 48,
                  color: Color(0xFF2B2B2B),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3F1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2B2B2B), width: 1.1),
              ),
              child: const Center(
                child: Text(
                  'Ayşe Yılmaz\nayse@example.com',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const _ProfileRow(label: 'Aktivite tercihi', value: 'Bisiklet'),
            const SizedBox(height: 10),
            const _ProfileRow(label: 'Sıcaklık birimi', value: '°C'),
            const SizedBox(height: 10),
            const _ProfileRow(label: 'Bildirimler', value: 'Açık'),
            const SizedBox(height: 10),
            const _ProfileRow(label: 'Dil', value: 'Türkçe'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE04B4B),
                  side: const BorderSide(color: Color(0xFFE04B4B), width: 1.4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Çıkış yap',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F3F1),
        border: Border.all(color: const Color(0xFF2B2B2B), width: 1.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E2E2E),
            ),
          ),
        ],
      ),
    );
  }
}
