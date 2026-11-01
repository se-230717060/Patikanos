import 'package:flutter/material.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({
    super.key,
    required this.selectedActivity,
    required this.onActivitySelected,
  });

  final String selectedActivity;
  final ValueChanged<String> onActivitySelected;

  @override
  Widget build(BuildContext context) {
    final activities = ['Bisiklet', 'Yürüyüş', 'İkisi de'];

    return Container(
      color: const Color(0xFFE9E4DF),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Patikanos',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                Text(
                  '1 / 2',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B3B3B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F1EE),
                border: Border.all(color: const Color(0xFF2B2B2B), width: 1.2),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: const Text(
                '[Görsel: Muğla Rotası]',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Bugün hangi rota, hangi saatte?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F1F1F),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Hava durumuna göre bisiklet ve yürüyüş için en uygun zamanı gösteririz.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF3B3B3B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Ne yapması istersiniz?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E2E2E),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: activities.map((activity) {
                final isSelected = activity == selectedActivity;
                return InkWell(
                  onTap: () => onActivitySelected(activity),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1D7A68) : const Color(0xFFF5F4F2),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF1D7A68) : const Color(0xFF2B2B2B),
                        width: 1.15,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      activity,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : const Color(0xFF232323),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D7A68),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Devam',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Atla',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF2B2B2B),
                    fontWeight: FontWeight.w600,
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
