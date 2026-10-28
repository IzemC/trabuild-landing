import 'package:flutter/material.dart';
import 'package:landing/constants/app_colors.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class VideoPlayerWidget extends StatefulWidget {
  final String? videoUrl;

  const VideoPlayerWidget({
    super.key,
    this.videoUrl,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPlaying = false;
  String? _viewId;
  html.VideoElement? _videoElement;

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
    _initVideoElement();
  }

  void _initVideoElement() {
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty && _isVideoUrl(widget.videoUrl!)) {
      _viewId = 'video-player-${DateTime.now().millisecondsSinceEpoch}';
      _videoElement = html.VideoElement()
        ..src = widget.videoUrl!
        ..autoplay = false
        ..controls = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.borderRadius = '16px';

      _videoElement!.onEnded.listen((_) {
        setState(() {
          _isPlaying = false;
        });
      });

      // Register the view factory
      ui_web.platformViewRegistry.registerViewFactory(
        _viewId!,
        (int viewId) => _videoElement!,
      );
    }
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _isPlaying = false;
      _initVideoElement();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoElement?.pause();
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

  void _togglePlay() {
    if (widget.videoUrl == null || widget.videoUrl!.isEmpty) return;

    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _videoElement?.play();
    } else {
      _videoElement?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = widget.videoUrl != null && widget.videoUrl!.isNotEmpty;
    final isVideo = hasVideo && _isVideoUrl(widget.videoUrl!);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Video player (hidden until playing)
            if (isVideo && _viewId != null)
              Positioned.fill(
                child: HtmlElementView(viewType: _viewId!),
              ),

            // Overlay with play button (shown when not playing)
            if (!_isPlaying)
              Positioned.fill(
                child: MouseRegion(
                  onEnter: (_) => _onHover(true),
                  onExit: (_) => _onHover(false),
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _togglePlay,
                    child: Container(
                      decoration: BoxDecoration(
                        color: hasVideo ? Colors.black.withOpacity(0.4) : AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                            child: Icon(
                              hasVideo ? Icons.play_arrow : Icons.videocam_off,
                              color: AppColors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // "No video" text if no video
            if (!hasVideo)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Text(
                  'Video coming soon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isVideoUrl(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mov') ||
        lower.contains('.mp4?') ||
        lower.contains('.webm?') ||
        lower.contains('.mov?');
  }
}
