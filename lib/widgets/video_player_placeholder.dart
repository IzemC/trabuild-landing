import 'package:flutter/material.dart';
import 'package:landing/constants/app_colors.dart';

class VideoPlayerPlaceholder extends StatefulWidget {
  final double? width;
  final double? height;
  final VoidCallback? onPlay;

  const VideoPlayerPlaceholder({
    super.key,
    this.width,
    this.height,
    this.onPlay,
  });

  @override
  State<VideoPlayerPlaceholder> createState() => _VideoPlayerPlaceholderState();
}

class _VideoPlayerPlaceholderState extends State<VideoPlayerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hover) {
    setState(() {
      _isHovered = hover;
    });
    if (hover) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onPlay,
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AppColors.white.withOpacity(0.3)
                      : AppColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: AppColors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
