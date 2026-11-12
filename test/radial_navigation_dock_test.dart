import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar_finance/l10n/generated/app_localizations.dart';
import 'package:masar_finance/src/widgets/radial_navigation_dock.dart';

void main() {
  testWidgets('four destinations rotate safely and keep Add available', (
    tester,
  ) async {
    final rotationController = AnimationController.unbounded(
      vsync: const TestVSync(),
      value: 0,
    );
    addTearDown(rotationController.dispose);
    var selected = 0;
    var adds = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: StatefulBuilder(
          builder:
              (context, setState) => Scaffold(
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: RadialNavigationDock(
                    rotationController: rotationController,
                    selectedIndex: selected,
                    locale: const Locale('en'),
                    onDestinationSelected:
                        (index) => setState(() {
                          selected = index;
                        }),
                    onAdd: () => adds++,
                  ),
                ),
              ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome_rounded), findsNothing);

    for (final destination in [
      'Transactions',
      'Reports',
      'Financial Goals',
      'Home',
    ]) {
      await tester.drag(
        find.byType(RadialNavigationDock),
        const Offset(-50, 0),
      );
      await tester.pumpAndSettle();
      expect(selected, inInclusiveRange(0, 3));
      expect(find.text(destination), findsOneWidget);
    }

    expect(selected, 0);
    await tester.drag(find.byType(RadialNavigationDock), const Offset(45, 0));
    await tester.pumpAndSettle();
    expect(selected, inInclusiveRange(0, 3));

    final dock = find.byType(RadialNavigationDock);
    for (final direction in [
      const Offset(-45, 0),
      const Offset(45, 0),
      const Offset(-90, 0),
      const Offset(90, 0),
    ]) {
      await tester.drag(dock, direction);
      await tester.pump(const Duration(milliseconds: 16));
      expect(tester.takeException(), isNull);
    }
    await tester.pumpAndSettle();
    expect(selected, inInclusiveRange(0, 3));

    await tester.tap(find.byIcon(Icons.receipt_long_rounded));
    await tester.pumpAndSettle();
    expect(selected, 1);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    expect(adds, 1);
  });
}
