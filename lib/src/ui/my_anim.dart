import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// MyAnimCtrl
class MyAnimCtrl {
  MyAnimCtrl({required this.animate});
  final void Function(Duration) animate;
}

class MyAnim extends StatefulWidget {
  const MyAnim({
    super.key,
    required this.onBuild,
    required this.onDone,
    required this.builder,
  });

  final void Function(MyAnimCtrl) onBuild;
  final void Function() onDone;
  final Widget Function(double) builder;

  @override
  State<MyAnim> createState() => _MyAnimState();
}

class _MyAnimState extends State<MyAnim> {
  Timer? _timer;
  var _value = 0.0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _buildCallback());
  }

  void _buildCallback() {
    widget.onBuild(MyAnimCtrl(animate: _run));
  }

  void _run(Duration duration) async {
    _timer?.cancel();
    _timer = null;
    _value = 0.0;

    final split = duration.inMilliseconds ~/ 50;

    _timer = Timer.periodic(
      Duration(milliseconds: split.toInt()),
      (timer) {
        var val = _value + (1 / 50);
        val = (val * 10000).toInt() / 10000;
        if (val > 1.0) val = 1.0;

        setState(() => _value = val);

        if (_value == 1.0) {
          _value = 0.0;
          _timer?.cancel();
          _timer = null;
          widget.onDone();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_value);
  }
}
