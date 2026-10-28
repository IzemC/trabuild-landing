import 'package:flutter/material.dart';
import 'package:landing/constants/app_colors.dart';
import 'package:landing/constants/app_strings.dart';
import 'package:landing/services/api_service.dart';
import 'package:landing/widgets/network_image_widget.dart';

class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
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
        final images = content?.images ?? [];

        // Get tagline from API (text1), fallback to hardcoded
        final tagline = _getTextValue(content, 0) ?? AppStrings.tagline;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
            vertical: isMobile ? 40 : 60,
          ),
          child: Column(
            children: [
              // First row: Title + Image 1
              if (isMobile)
                _buildMobileLayout(images, tagline)
              else
                _buildDesktopLayout(isTablet, images, tagline),

              SizedBox(height: isMobile ? 24 : 40),

              // Row of 5 smaller images
              _buildImageRow(isMobile, isTablet, images),
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

  String? _getImageUrl(List<WebPageContentItem> images, int index) {
    if (index < images.length) {
      return images[index].url;
    }
    return null;
  }

  Widget _buildMobileLayout(List<WebPageContentItem> images, String tagline) {
    return Column(
      children: [
        // Title
        Text(
          tagline,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Image 1
        AspectRatio(
          aspectRatio: 4 / 3,
          child: NetworkImageWidget(
            imageUrl: _getImageUrl(images, 0),
            fallbackLabel: 'IMAGE\n1',
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
        ),
        const SizedBox(height: 24),

        // Image 2
        AspectRatio(
          aspectRatio: 4 / 3,
          child: NetworkImageWidget(
            imageUrl: _getImageUrl(images, 1),
            fallbackLabel: 'IMAGE\n2',
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
        ),
        const SizedBox(height: 16),

        // Title for Image 2
        Text(
          tagline,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isTablet, List<WebPageContentItem> images, String tagline) {
    return Column(
      children: [
        // First row: Title on left, Image 1 on right
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Text(
                  tagline,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: isTablet ? 28 : 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: NetworkImageWidget(
                  imageUrl: _getImageUrl(images, 0),
                  fallbackLabel: 'IMAGE\n1',
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),

        // Second row: Image 2 on left, Title on right
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: NetworkImageWidget(
                  imageUrl: _getImageUrl(images, 1),
                  fallbackLabel: 'IMAGE\n2',
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  tagline,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: isTablet ? 28 : 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageRow(bool isMobile, bool isTablet, List<WebPageContentItem> apiImages) {
    final labels = ['IMAGE\n3', 'IMAGE\n4', 'IMAGE\n5', 'IMAGE\n6', 'IMAGE\n7'];
    final double spacing = isMobile ? 8 : 16;

    if (isMobile) {
      // Horizontal scroll on mobile
      return SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: labels.length,
          separatorBuilder: (_, __) => SizedBox(width: spacing),
          itemBuilder: (context, index) {
            return SizedBox(
              width: 100,
              child: NetworkImageWidget(
                imageUrl: _getImageUrl(apiImages, index + 2), // Start from image3 (index 2)
                fallbackLabel: labels[index],
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
            );
          },
        ),
      );
    }

    // Grid on desktop/tablet
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing / 2),
              child: AspectRatio(
                aspectRatio: 1,
                child: NetworkImageWidget(
                  imageUrl: _getImageUrl(apiImages, index + 2), // Start from image3 (index 2)
                  fallbackLabel: labels[index],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
