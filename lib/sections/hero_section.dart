import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landing/constants/app_colors.dart';
import 'package:landing/constants/app_strings.dart';
import 'package:landing/services/api_service.dart';
import 'package:landing/widgets/video_player_widget.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late Future<LandingContent> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = ApiService().getLandingContent();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return FutureBuilder<LandingContent>(
      future: _contentFuture,
      builder: (context, snapshot) {
        final content = snapshot.data;
        final videoUrl = content?.video?.url;

        // Get text content from API, fallback to hardcoded strings
        final tagline = _getTextValue(content, 0) ?? AppStrings.tagline;
        final subtitle = _getTextValue(content, 1) ?? AppStrings.subtitle;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
            vertical: isMobile ? 40 : 60,
          ),
          child: Column(
            children: [
              // Logo
              _buildLogo(isMobile),
              SizedBox(height: isMobile ? 24 : 40),

              // Tagline (text1 from API)
              Text(
                tagline,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: isMobile ? 20 : (isTablet ? 28 : 32),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle (text2 from API)
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 32 : 48),

              // Video Player
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : 800,
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: VideoPlayerWidget(
                    videoUrl: videoUrl,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Get text value from API content, returns null if not available
  String? _getTextValue(LandingContent? content, int index) {
    if (content == null || index >= content.texts.length) return null;
    final text = content.texts[index];
    return text.value.isNotEmpty ? text.value : null;
  }

  Widget _buildLogo(bool isMobile) {
    return SvgPicture.asset(
      'assets/images/trabuild.svg',
      height: isMobile ? 24 : 31,
    );
  }
}
