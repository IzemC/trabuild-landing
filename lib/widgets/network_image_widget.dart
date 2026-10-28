import 'package:flutter/material.dart';
import 'package:landing/constants/app_colors.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String fallbackLabel;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const NetworkImageWidget({
    super.key,
    this.imageUrl,
    required this.fallbackLabel,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final radius = borderRadius ?? BorderRadius.circular(16);

    if (hasImage) {
      return ClipRRect(
        borderRadius: radius,
        child: Image.network(
          imageUrl!,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildPlaceholder(
              radius,
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: AppColors.white,
                strokeWidth: 2,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(radius);
          },
        ),
      );
    }

    return _buildPlaceholder(radius);
  }

  Widget _buildPlaceholder(BorderRadius radius, {Widget? child}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: radius,
      ),
      child: Center(
        child: child ??
            Text(
              fallbackLabel,
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
