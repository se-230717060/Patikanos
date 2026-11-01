import 'package:flutter_test/flutter_test.dart';

import 'package:patikanos/main.dart';

void main() {
  testWidgets('Shows the real app with bottom navigation and action buttons',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Patikanos'), findsOneWidget);
    expect(find.text('Bugün hangi rota, hangi saatte?'), findsOneWidget);
    expect(find.text('Bisiklet'), findsWidgets);
    expect(find.text('Devam'), findsOneWidget);

    await tester.tap(find.text('Keşfet'));
    await tester.pumpAndSettle();
    expect(find.text('Keşfet'), findsWidgets);
    expect(find.text('Rotalar'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Profil ve Ayarlar'), findsOneWidget);
  });
}
