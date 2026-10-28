import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:landing/constants/app_colors.dart';

enum StoreType { googlePlay, appStore }

class StoreButton extends StatefulWidget {
  final StoreType storeType;
  final VoidCallback? onPressed;

  const StoreButton({
    super.key,
    required this.storeType,
    this.onPressed,
  });

  @override
  State<StoreButton> createState() => _StoreButtonState();
}

class _StoreButtonState extends State<StoreButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isGooglePlay = widget.storeType == StoreType.googlePlay;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.white.withOpacity(0.1) : Colors.transparent,
            border: Border.all(color: AppColors.white, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                isGooglePlay ? FontAwesomeIcons.googlePlay : FontAwesomeIcons.apple,
                color: AppColors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Download on',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    isGooglePlay ? 'Google Play' : 'App Store',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
