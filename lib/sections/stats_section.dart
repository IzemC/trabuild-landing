import 'package:flutter/material.dart';
import 'package:landing/constants/app_colors.dart';
import 'package:landing/constants/app_strings.dart';
import 'package:landing/services/api_service.dart';
import 'package:landing/widgets/animated_counter.dart';
import 'package:landing/widgets/star_rating.dart';

class StatsSection extends StatefulWidget {
  const StatsSection({super.key});

  @override
  State<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection> {
  late Future<LandingStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = ApiService().getLandingStats();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 40 : 60,
      ),
      child: FutureBuilder<LandingStats>(
        future: _statsFuture,
        builder: (context, snapshot) {
          // Show loading state while waiting for API
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                _buildLoadingStatItem(label: AppStrings.studentsLabel, isMobile: isMobile),
                SizedBox(height: isMobile ? 32 : 48),
                _buildLoadingStatItem(label: AppStrings.coursesLabel, isMobile: isMobile),
                SizedBox(height: isMobile ? 32 : 48),
                StarRating(
                  rating: 0,
                  starSize: isMobile ? 28 : 36,
                  showLabel: true,
                ),
              ],
            );
          }

          // Use API data if available, otherwise use fallback
          final stats = snapshot.data ?? LandingStats.fallback();

          return Column(
            children: [
              // Students count
              _buildStatItem(
                label: AppStrings.studentsLabel,
                value: stats.studentsCount,
                isMobile: isMobile,
              ),
              SizedBox(height: isMobile ? 32 : 48),

              // Courses count
              _buildStatItem(
                label: AppStrings.coursesLabel,
                value: stats.coursesCount,
                isMobile: isMobile,
              ),
              SizedBox(height: isMobile ? 32 : 48),

              // Rating
              StarRating(
                rating: stats.averageRating,
                starSize: isMobile ? 28 : 36,
                showLabel: true,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required int value,
    required bool isMobile,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.white,
            fontSize: isMobile ? 16 : 20,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        AnimatedCounter(
          endValue: value,
          duration: const Duration(milliseconds: 2500),
          textStyle: TextStyle(
            color: AppColors.white,
            fontSize: isMobile ? 36 : 48,
            fontWeight: FontWeight.bold,
          ),
          useCommas: true,
        ),
      ],
    );
  }

  Widget _buildLoadingStatItem({
    required String label,
    required bool isMobile,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.white,
            fontSize: isMobile ? 16 : 20,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '...',
          style: TextStyle(
            color: AppColors.white.withOpacity(0.5),
            fontSize: isMobile ? 36 : 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
