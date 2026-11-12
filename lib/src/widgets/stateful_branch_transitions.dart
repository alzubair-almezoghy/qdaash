import 'package:flutter/material.dart';

/// Keeps each branch mounted and derives its visual transition from the wheel.
class StatefulBranchTransitions extends StatefulWidget {
  const StatefulBranchTransitions({
    required this.rotationController,
    required this.children,
    this.isRtl = false,
    super.key,
  });

  final AnimationController rotationController;
  final List<Widget> children;
  final bool isRtl;

  @override
  State<StatefulBranchTransitions> createState() =>
      _StatefulBranchTransitionsState();
}

class _StatefulBranchTransitionsState extends State<StatefulBranchTransitions> {
  late double _lastAngle;
  double _travelDirection = 1;

  @override
  void initState() {
    super.initState();
    _lastAngle = widget.rotationController.value;
  }

  @override
  void didUpdateWidget(covariant StatefulBranchTransitions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rotationController != widget.rotationController) {
      _lastAngle = widget.rotationController.value;
      _travelDirection = 1;
    }
  }

  int _mod(int value) =>
      (value % widget.children.length + widget.children.length) %
      widget.children.length;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.rotationController,
    builder: (context, _) {
      if (widget.children.isEmpty) return const SizedBox.shrink();

      final angle = widget.rotationController.value;
      final movement = angle - _lastAngle;
      if (movement.abs() > 0.000001) {
        _travelDirection = movement.sign;
        _lastAngle = angle;
      }

      final nearestInteger = angle.roundToDouble();
      final atRestingIndex = (angle - nearestInteger).abs() < 0.000001;
      final lowerIndex = angle.floor();
      final upperIndex = angle.ceil();
      final rawOutgoingIndex =
          atRestingIndex
              ? nearestInteger.toInt()
              : _travelDirection > 0
              ? lowerIndex
              : upperIndex;
      final outgoingIndex = _mod(rawOutgoingIndex);
      final incomingIndex = _mod(rawOutgoingIndex + _travelDirection.toInt());
      final progress =
          atRestingIndex
              ? 0.0
              : _travelDirection > 0
              ? angle - lowerIndex
              : upperIndex - angle;
      final indices = <int>[
        for (var index = 0; index < widget.children.length; index++)
          if (index != outgoingIndex && index != incomingIndex) index,
        outgoingIndex,
        incomingIndex,
      ];
      final direction = (widget.isRtl ? -1.0 : 1.0) * _travelDirection;

      // The clip belongs to the viewport, not either moving page. At every
      // point in the transition the two page bounds meet without overlapping.
      return ClipRect(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          fit: StackFit.expand,
          children: [
            for (final index in indices)
              Positioned.fill(
                key: ValueKey<int>(index),
                child: _NavigationBranchLayer(
                  index: index,
                  outgoingIndex: outgoingIndex,
                  incomingIndex: incomingIndex,
                  progress: progress,
                  direction: direction,
                  child: widget.children[index],
                ),
              ),
          ],
        ),
      );
    },
  );
}

class _NavigationBranchLayer extends StatelessWidget {
  const _NavigationBranchLayer({
    required this.index,
    required this.outgoingIndex,
    required this.incomingIndex,
    required this.progress,
    required this.direction,
    required this.child,
  });

  final int index;
  final int outgoingIndex;
  final int incomingIndex;
  final double progress;
  final double direction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isOutgoing = index == outgoingIndex;
    final isIncoming = index == incomingIndex && progress > 0;
    final visible = isOutgoing || isIncoming;
    final translation =
        isOutgoing
            ? -direction * progress
            : isIncoming
            ? direction * (1 - progress)
            : 0.0;
    final background = Theme.of(context).scaffoldBackgroundColor;

    return Offstage(
      offstage: !visible,
      child: TickerMode(
        enabled: visible,
        child: IgnorePointer(
          ignoring: progress > 0,
          child: ExcludeSemantics(
            excluding: isIncoming,
            // Solid branch surfaces prevent transparent page areas from
            // exposing content belonging to another route.
            child: FractionalTranslation(
              translation: Offset(translation, 0),
              child: RepaintBoundary(
                child: ColoredBox(color: background, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
