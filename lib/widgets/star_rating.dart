import 'package:flutter/material.dart';
import 'package:landing/constants/app_colors.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double starSize;
  final bool showLabel;

  const StarRating({
    super.key,
    required this.rating,
    this.starSize = 24,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final int fullStars = rating.floor();
    final bool hasHalfStar = (rating - fullStars) >= 0.5;
    final int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                color: AppColors.white,
                fontSize: starSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ...List.generate(
          fullStars,
          (_) => Icon(
            Icons.star,
            color: AppColors.primary,
            size: starSize,
          ),
        ),
        if (hasHalfStar)
          Icon(
            Icons.star_half,
            color: AppColors.primary,
            size: starSize,
          ),
        ...List.generate(
          emptyStars,
          (_) => Icon(
            Icons.star_border,
            color: AppColors.primary,
            size: starSize,
          ),
        ),
      ],
    );
  }
}
