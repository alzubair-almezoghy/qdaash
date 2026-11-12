import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar_finance/src/widgets/stateful_branch_transitions.dart';

void main() {
  testWidgets('page motion follows wheel progress and retains branch state', (
    tester,
  ) async {
    final rotationController = AnimationController.unbounded(
      vsync: const TestVSync(),
      value: 0,
    );
    addTearDown(rotationController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBranchTransitions(
            rotationController: rotationController,
            children: const [
              _CounterBranch(label: 'Home'),
              _CounterBranch(label: 'Transactions'),
              _CounterBranch(label: 'Reports'),
              _CounterBranch(label: 'Goals'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Home: 0'), findsOneWidget);
    rotationController.value = 0.5;
    await tester.pump();
    expect(find.text('Home: 0'), findsOneWidget);
    expect(find.text('Transactions: 0'), findsOneWidget);
    expect(find.byType(ClipRect), findsOneWidget);
    expect(find.byType(RepaintBoundary), findsAtLeastNWidgets(2));
    final movingPages =
        tester
            .widgetList<FractionalTranslation>(
              find.byType(FractionalTranslation),
            )
            .where((page) => page.translation.dx != 0)
            .map((page) => page.translation.dx)
            .toList();
    expect(movingPages, containsAll(<double>[-0.5, 0.5]));

    rotationController.value = 1;
    await tester.pump();
    expect(find.text('Transactions: 0'), findsOneWidget);
    await tester.tap(find.text('Add one'));
    await tester.pump();
    expect(find.text('Transactions: 1'), findsOneWidget);

    rotationController.value = 0;
    await tester.pump();
    expect(find.text('Home: 0'), findsOneWidget);
    rotationController.value = 1;
    await tester.pump();
    expect(find.text('Transactions: 1'), findsOneWidget);
    expect(tester.takeException(), isNull);

    rotationController.value = 0;
    await tester.pump();
    rotationController.value = -0.5;
    await tester.pump();
    expect(find.text('Home: 0'), findsOneWidget);
    expect(find.text('Goals: 0'), findsOneWidget);
    expect(find.text('Transactions: 0'), findsNothing);

    rotationController.value = -1;
    await tester.pump();
    expect(find.text('Goals: 0'), findsOneWidget);
    expect(find.text('Home: 0'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _CounterBranch extends StatefulWidget {
  const _CounterBranch({required this.label});

  final String label;

  @override
  State<_CounterBranch> createState() => _CounterBranchState();
}

class _CounterBranchState extends State<_CounterBranch> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('${widget.label}: $_count'),
      TextButton(
        onPressed: () => setState(() => _count++),
        child: const Text('Add one'),
      ),
    ],
  );
}
