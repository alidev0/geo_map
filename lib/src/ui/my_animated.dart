import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class MyAnimatedCtrl {
  MyAnimatedCtrl({required this.forward, required this.reverse});
  final void Function() forward;
  final void Function() reverse;
}

class MyAnimated extends StatefulWidget {
  const MyAnimated({
    super.key,
    required this.builder,
    required this.onBuild,
    required this.onDone,
    required this.reset,
  });
  final Widget Function(double) builder;
  final void Function(MyAnimatedCtrl) onBuild;
  final void Function() onDone;
  final bool reset;

  @override
  State<MyAnimated> createState() => _MyAnimatedState();
}

class _MyAnimatedState extends State<MyAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    const duration = Duration(milliseconds: 2000);
    _ctrl = AnimationController(duration: duration, vsync: this);
    _ctrl.addStatusListener((status) {
      if (mounted && status == AnimationStatus.completed) {
        _ctrl.reset();
        widget.onDone();
      }
    });
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _buildCallback());
  }

  void _buildCallback() => widget.onBuild(
        MyAnimatedCtrl(forward: _ctrl.forward, reverse: _ctrl.reverse),
      );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MyAnimated oldWidget) {
    if (!_ctrl.isCompleted) _ctrl.reset();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl.view,
      builder: (p0, p1) => widget.builder(_ctrl.value),
    );
  }
}
