import 'package:flutter/material.dart';
import 'package:landing/services/api_service.dart';
import 'package:landing/widgets/store_button.dart';
import 'package:url_launcher/url_launcher.dart';

class CtaSection extends StatelessWidget {
  final LandingSettings settings;

  const CtaSection({super.key, required this.settings});

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
      child: Column(
        children: [
          // Store buttons
          if (isMobile)
            Column(
              children: [
                StoreButton(
                  storeType: StoreType.googlePlay,
                  onPressed: () => _launchUrl(settings.playStoreUrl),
                ),
                const SizedBox(height: 16),
                StoreButton(
                  storeType: StoreType.appStore,
                  onPressed: () => _launchUrl(settings.appStoreUrl),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StoreButton(
                  storeType: StoreType.googlePlay,
                  onPressed: () => _launchUrl(settings.playStoreUrl),
                ),
                const SizedBox(width: 24),
                StoreButton(
                  storeType: StoreType.appStore,
                  onPressed: () => _launchUrl(settings.appStoreUrl),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
