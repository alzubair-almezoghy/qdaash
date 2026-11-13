import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import '../../l10n/generated/app_localizations.dart';

import '../theme.dart';

class RadialNavigationDock extends StatefulWidget {
  const RadialNavigationDock({
    required this.rotationController,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onAdd,
    required this.locale,
    this.haptics = true,
    this.reduceMotion = false,
    this.itemAngularSpacing = 0.34,
    super.key,
  });

  final AnimationController rotationController;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onAdd;
  final Locale locale;
  final bool haptics;
  final bool reduceMotion;
  final double itemAngularSpacing;

  @override
  State<RadialNavigationDock> createState() => _RadialNavigationDockState();
}

class _RadialNavigationDockState extends State<RadialNavigationDock> {
  static const double _visibleArcHeight = 108;
  static const double _collapsedHeight = 92;
  static const double _selectedIconCenterY = 40;
  static const double _itemTouchSize = 44;

  AnimationController get _rotation => widget.rotationController;
  bool _expanded = true;
  bool _dragging = false;
  bool _settling = false;
  bool _pressed = false;
  double _dragOrigin = 0;
  double _dragStartX = 0;
  double? _pendingTarget;
  int? _pendingSelection;

  bool get _ar => widget.locale.languageCode == 'ar';

  List<_Destination> get _items => [
    _Destination(0, Icons.home_rounded, AppLocalizations.of(context)!.navHome),
    _Destination(
      1,
      Icons.receipt_long_rounded,
      AppLocalizations.of(context)!.navTransactions,
    ),
    _Destination(
      2,
      Icons.insert_chart_rounded,
      AppLocalizations.of(context)!.navReports,
    ),
    _Destination(3, Icons.flag_rounded, AppLocalizations.of(context)!.navGoals),
    _Destination(
      4,
      Icons.settings_rounded,
      AppLocalizations.of(context)!.settings,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _rotation.addStatusListener(_onStatus);
  }

  @override
  void didUpdateWidget(covariant RadialNavigationDock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rotationController != widget.rotationController) {
      oldWidget.rotationController.removeStatusListener(_onStatus);
      _rotation.addStatusListener(_onStatus);
    }
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      if (_settling && _pendingSelection == widget.selectedIndex) return;
      _rotation.stop();
      _dragging = false;
      _settling = false;
      _pendingSelection = null;
      _pendingTarget = null;
      final target = _nearestEquivalent(widget.selectedIndex);
      if (widget.reduceMotion) {
        _rotation.value = target;
      } else {
        _settle(target, 0);
      }
    }
  }

  @override
  void dispose() {
    _rotation.removeStatusListener(_onStatus);
    super.dispose();
  }

  int _mod(int value) =>
      (value % _items.length + _items.length) % _items.length;

  double _nearestEquivalent(int index) {
    final cycle = (_rotation.value - index) / _items.length;
    final lower = index + cycle.floor() * _items.length;
    final upper = lower + _items.length;
    return (_rotation.value - lower).abs() <= (_rotation.value - upper).abs()
        ? lower.toDouble()
        : upper.toDouble();
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !_settling) return;
    _settling = false;
    final index = _pendingSelection;
    final target = _pendingTarget;
    _pendingSelection = null;
    _pendingTarget = null;
    if (index == null || target == null) return;

    _rotation.value = target;
    if (widget.haptics) HapticFeedback.selectionClick();
    if (index == widget.selectedIndex) return;

    widget.onDestinationSelected(index);
  }

  void _select(int index) {
    _rotation.stop();
    _settling = false;
    _pendingSelection = null;
    _pendingTarget = null;
    final target = _nearestEquivalent(index);
    if ((target - _rotation.value).abs() < 0.015) {
      if (index != widget.selectedIndex) {
        if (widget.haptics) HapticFeedback.selectionClick();
        widget.onDestinationSelected(index);
      }
      return;
    }
    _settle(target, 0);
  }

  void _dragStart(DragStartDetails details) {
    _rotation.stop();
    _settling = false;
    _pendingSelection = null;
    _pendingTarget = null;
    _dragging = true;
    _dragOrigin = _rotation.value;
    _dragStartX = details.localPosition.dx;
  }

  void _dragUpdate(DragUpdateDetails details) {
    if (!_dragging) return;
    _rotation.value =
        _dragOrigin - (details.localPosition.dx - _dragStartX) / 50;
  }

  void _dragEnd(DragEndDetails details) {
    if (!_dragging) return;
    _dragging = false;
    final velocity = -details.velocity.pixelsPerSecond.dx / 50;
    var predicted = _rotation.value;
    if (velocity.abs() > 0.55) {
      predicted += velocity.clamp(-6.0, 6.0) * 0.12;
    }
    final nearest = predicted.roundToDouble();
    final target =
        nearest.clamp(_rotation.value - 2.0, _rotation.value + 2.0).toDouble();
    _settle(target, velocity.clamp(-7.0, 7.0).toDouble());
  }

  void _dragCancel() {
    if (!_dragging) return;
    _dragging = false;
    _settle(_rotation.value.roundToDouble(), 0);
  }

  void _settle(double target, double velocity) {
    final selection = _mod(target.round());
    if (widget.reduceMotion) {
      _rotation.value = target;
      if (selection != widget.selectedIndex) {
        if (widget.haptics) HapticFeedback.selectionClick();
        widget.onDestinationSelected(selection);
      }
      return;
    }
    if ((target - _rotation.value).abs() < 0.01) {
      _rotation.value = target;
      if (selection != widget.selectedIndex) {
        if (widget.haptics) HapticFeedback.selectionClick();
        widget.onDestinationSelected(selection);
      }
      return;
    }

    _settling = true;
    _pendingSelection = selection;
    _pendingTarget = target;
    // Ask GoRouter to build an unvisited branch as soon as the wheel starts
    // settling. Its first frame can then participate in this same transition
    // instead of appearing only after the wheel has stopped.
    if (selection != widget.selectedIndex) {
      widget.onDestinationSelected(selection);
    }
    _rotation.animateWith(
      SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 190, damping: 23),
        _rotation.value,
        target,
        velocity,
      ),
    );
  }

  void _toggleExpanded() {
    if (widget.haptics) HapticFeedback.selectionClick();
    setState(() => _expanded = !_expanded);
  }

  void _add() {
    if (widget.haptics) HapticFeedback.lightImpact();
    widget.onAdd();
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final height = _expanded ? _visibleArcHeight : _collapsedHeight;
    return AnimatedContainer(
      duration:
          widget.reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      height: height + safeBottom,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(bottom: safeBottom),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onHorizontalDragStart: _expanded ? _dragStart : null,
              onHorizontalDragUpdate: _expanded ? _dragUpdate : null,
              onHorizontalDragEnd: _expanded ? _dragEnd : null,
              onHorizontalDragCancel: _expanded ? _dragCancel : null,
              child: ClipRect(
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    if (_expanded)
                      RepaintBoundary(
                        child: AnimatedBuilder(
                          animation: _rotation,
                          builder: (context, _) => _buildVisibleItems(width),
                        ),
                      ),
                    if (_expanded)
                      Positioned(
                        right: 8,
                        top: 1,
                        child: _SmallButton(
                          icon: Icons.keyboard_arrow_down_rounded,
                          label:
                              AppLocalizations.of(context)!.collapseNavigation,
                          onTap: _toggleExpanded,
                        ),
                      ),
                    if (_expanded)
                      Positioned(
                        left: width / 2 - 19,
                        bottom: 1,
                        child: _addButton(),
                      ),
                    if (!_expanded) _collapsed(width),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double _radius(double width) =>
      math.min(220.0, math.max(155.0, width * 0.52));

  Widget _buildVisibleItems(double width) {
    final whole = _rotation.value.floor();
    final fraction = _rotation.value - whole;
    final radius = _radius(width);
    final children = <Widget>[];

    // Keep a pair of edge destinations mounted outside the visible three.
    // They fade in as they approach the wheel instead of popping into view
    // when the selected index crosses an integer.
    for (var slot = -2; slot <= 2; slot++) {
      final offset = slot - fraction;
      final angle = offset * widget.itemAngularSpacing;
      final x = width / 2 + radius * math.sin(angle);
      final y = _selectedIconCenterY + radius * (1 - math.cos(angle));
      final focus = (1 - offset.abs()).clamp(0.0, 1.0).toDouble();
      final opacity = (2 - offset.abs()).clamp(0.0, 1.0).toDouble();
      final destination = _items[_mod(whole + slot)];
      children.add(
        Positioned(
          key: ValueKey<int>(destination.index),
          left: x - _itemTouchSize / 2,
          top: y - _itemTouchSize / 2,
          width: _itemTouchSize,
          height: _itemTouchSize,
          child: _DialItem(
            destination: destination,
            focus: focus,
            opacity: opacity,
            direction: _ar ? TextDirection.rtl : TextDirection.ltr,
            onTap: () => _select(_mod(whole + slot)),
          ),
        ),
      );
    }

    final rounded = _mod(_rotation.value.round());
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        ...children,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Center(
              child: Text(
                _items[rounded].label,
                textDirection: _ar ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _addButton() => GestureDetector(
    onTapDown: (_) => setState(() => _pressed = true),
    onTapCancel: () => setState(() => _pressed = false),
    onTapUp: (_) {
      setState(() => _pressed = false);
      _add();
    },
    child: AnimatedScale(
      scale: _pressed ? 0.92 : 1,
      duration:
          widget.reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 140),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.18),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
      ),
    ),
  );

  Widget _collapsed(double width) {
    final current = _items[widget.selectedIndex];
    return Stack(
      children: [
        Positioned(
          left: width / 2 - 22,
          top: 0,
          width: 44,
          height: 44,
          child: GestureDetector(
            onTap: _toggleExpanded,
            child: _DialItem(
              destination: current,
              focus: 1,
              opacity: 1,
              direction: _ar ? TextDirection.rtl : TextDirection.ltr,
              onTap: _toggleExpanded,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 43,
          child: IgnorePointer(
            child: Center(
              child: Text(
                current.label,
                textDirection: _ar ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Positioned(left: width / 2 - 19, bottom: 1, child: _addButton()),
        Positioned(
          right: 8,
          top: 1,
          child: _SmallButton(
            icon: Icons.keyboard_arrow_up_rounded,
            label: AppLocalizations.of(context)!.expandNavigation,
            onTap: _toggleExpanded,
          ),
        ),
      ],
    );
  }
}

class _Destination {
  const _Destination(this.index, this.icon, this.label);

  final int index;
  final IconData icon;
  final String label;
}

class _DialItem extends StatelessWidget {
  const _DialItem({
    required this.destination,
    required this.focus,
    required this.opacity,
    required this.direction,
    required this.onTap,
  });

  final _Destination destination;
  final double focus;
  final double opacity;
  final TextDirection direction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = focus >= 0.78;
    final size = 29 + 15 * focus;
    final scheme = Theme.of(context).colorScheme;
    final color =
        Color.lerp(
          scheme.onSurface.withValues(alpha: 0.48),
          scheme.primary,
          focus,
        )!;
    final iconColor = Color.lerp(color, Colors.white, focus)!;
    return IgnorePointer(
      ignoring: opacity < 0.35,
      child: Opacity(
        opacity: opacity,
        child: Semantics(
          button: true,
          selected: selected,
          label: destination.label,
          excludeSemantics: opacity < 0.5,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: SizedBox.expand(
              child: Center(
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: focus),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MasarColors.mint.withValues(alpha: 0.7 * focus),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.18 * focus),
                        blurRadius: 7 * focus,
                      ),
                    ],
                  ),
                  child: Icon(
                    destination.icon,
                    size: 15 + 8 * focus,
                    color: iconColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: label,
    child: Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    ),
  );
}
