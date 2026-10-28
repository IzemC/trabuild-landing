import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedCounter extends StatefulWidget {
  final int endValue;
  final Duration duration;
  final TextStyle? textStyle;
  final String? prefix;
  final String? suffix;
  final bool useCommas;

  const AnimatedCounter({
    super.key,
    required this.endValue,
    this.duration = const Duration(milliseconds: 2000),
    this.textStyle,
    this.prefix,
    this.suffix,
    this.useCommas = true,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isVisible = false;
  int _displayValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      // easeOutExpo gives a fast start and smooth deceleration
      curve: Curves.easeOutExpo,
    );

    _controller.addListener(_updateValue);
  }

  void _updateValue() {
    final newValue = (widget.endValue * _animation.value).round();
    if (newValue != _displayValue) {
      setState(() {
        _displayValue = newValue;
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endValue != widget.endValue && _isVisible) {
      // Reset and restart when value changes
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateValue);
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    if (!widget.useCommas) return number.toString();
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3 && !_isVisible) {
      _isVisible = true;
      // Small delay for a more polished feel
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('counter_${widget.endValue}_${widget.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Text(
        '${widget.prefix ?? ''}${_formatNumber(_displayValue)}${widget.suffix ?? ''}',
        style: widget.textStyle,
      ),
    );
  }
}
