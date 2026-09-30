import 'package:buno/main.dart';
import 'package:buno/widgets/buno_bottom_nav.dart';
import 'package:buno/widgets/buno_buttons.dart';
import 'package:buno/widgets/buno_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _loadFonts() async {
  final families = {
    'Sora': ['Sora-Regular', 'Sora-SemiBold', 'Sora-Bold'],
    'ReadexPro': [
      'ReadexPro-Regular',
      'ReadexPro-Medium',
      'ReadexPro-SemiBold',
      'ReadexPro-Bold',
    ],
  };
  for (final e in families.entries) {
    final loader = FontLoader(e.key);
    for (final f in e.value) {
      loader.addFont(rootBundle.load('assets/fonts/$f.ttf'));
    }
    await loader.load();
  }
}

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const BunoApp());
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(_loadFonts);

  // Reference frame first, then small/large phones.
  const sizes = [
    Size(390, 844), // iPhone 12-15 (the Brand Board frame)
    Size(375, 667), // iPhone SE
    Size(360, 640), // small Android
    Size(320, 568), // smallest supported width
    Size(430, 932), // iPhone Pro Max
    Size(412, 915), // Pixel
  ];

  for (final size in sizes) {
    testWidgets('no overflow and RTL at ${size.width.toInt()}x${size.height.toInt()}',
        (tester) async {
      await _pumpAt(tester, size);
      expect(tester.takeException(), isNull);

      final ctx = tester.element(find.byType(BunoPrimaryButton));
      expect(Directionality.of(ctx), TextDirection.rtl);

      // RTL mirrors the header: logo on the right, profile on the left.
      final logo = tester.getCenter(find.byType(BunoLogo));
      final profile = tester.getCenter(find.bySemanticsLabel('حسابي').first);
      expect(logo.dx, greaterThan(size.width / 2));
      expect(profile.dx, lessThan(size.width / 2));

      // First nav item (home) sits on the right.
      final home = tester.getCenter(find.text('الرئيسية'));
      final account = tester.getCenter(find.text('حسابي').last);
      expect(home.dx, greaterThan(account.dx));
    });
  }

  testWidgets('interactions: search, CTA, bottom nav', (tester) async {
    await _pumpAt(tester, const Size(390, 844));

    await tester.enterText(find.byType(TextField), 'مول');
    await tester.pump();
    expect(find.text('مول'), findsOneWidget);

    await tester.tap(find.byType(BunoPrimaryButton));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    BunoBottomNav nav() => tester.widget(find.byType(BunoBottomNav));
    expect(nav().currentIndex, 0);
    await tester.tap(find.text('المحفظة'));
    await tester.pump();
    expect(nav().currentIndex, 2);
    expect(tester.takeException(), isNull);
  });
}
