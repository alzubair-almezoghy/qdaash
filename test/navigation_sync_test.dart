import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar_finance/l10n/generated/app_localizations.dart';
import 'package:masar_finance/src/widgets/radial_navigation_dock.dart';
import 'package:masar_finance/src/widgets/stateful_branch_transitions.dart';

void main() {
  testWidgets('page transition tracks and reverses with the radial wheel', (
    tester,
  ) async {
    final rotationController = AnimationController.unbounded(
      vsync: const TestVSync(),
      value: 0,
    );
    addTearDown(rotationController.dispose);
    var selectedIndex = 0;

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
                body: Column(
                  children: [
                    Expanded(
                      child: StatefulBranchTransitions(
                        rotationController: rotationController,
                        children: const [
                          Center(child: Text('Home page')),
                          Center(child: Text('Transactions page')),
                          Center(child: Text('Reports page')),
                          Center(child: Text('Goals page')),
                          Center(child: Text('Settings page')),
                        ],
                      ),
                    ),
                    RadialNavigationDock(
                      rotationController: rotationController,
                      selectedIndex: selectedIndex,
                      locale: const Locale('en'),
                      onDestinationSelected:
                          (index) => setState(() => selectedIndex = index),
                      onAdd: () {},
                    ),
                  ],
                ),
              ),
        ),
      ),
    );

    rotationController.value = 0.5;
    await tester.pump();
    expect(rotationController.value, closeTo(0.5, 0.01));
    expect(find.text('Home page'), findsOneWidget);
    expect(find.text('Transactions page'), findsOneWidget);

    rotationController.value = 0;
    await tester.pump();
    expect(selectedIndex, 0);
    expect(find.text('Home page'), findsOneWidget);

    await tester.drag(find.byType(RadialNavigationDock), const Offset(-50, 0));
    expect(selectedIndex, 1);
    expect(rotationController.value, isNot(closeTo(1, 0.01)));
    await tester.pumpAndSettle();
    expect(rotationController.value, closeTo(1, 0.01));
    expect(selectedIndex, 1);
    expect(find.text('Transactions page'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
