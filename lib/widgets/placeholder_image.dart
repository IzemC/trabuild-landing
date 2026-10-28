import 'package:flutter/material.dart';
import 'package:landing/constants/app_colors.dart';

class PlaceholderImage extends StatelessWidget {
  final String label;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const PlaceholderImage({
    super.key,
    required this.label,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
