import 'package:flutter/material.dart';
import 'package:landing/sections/hero_section.dart';
import 'package:landing/sections/gallery_section.dart';
import 'package:landing/sections/stats_section.dart';
import 'package:landing/sections/cta_section.dart';
import 'package:landing/sections/contact_section.dart';
import 'package:landing/sections/footer_section.dart';
import 'package:landing/services/api_service.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  LandingSettings _settings = LandingSettings.fallback();

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    final settings = await ApiService().getPublicSettings();
    if (mounted) {
      setState(() => _settings = settings);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: true,
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Hero Section with logo, tagline, and video
              const HeroSection(),

              // Gallery Section with images
              const GallerySection(),

              // Stats Section with animated counters
              const StatsSection(),

              // CTA Section with store buttons
              CtaSection(settings: _settings),

              // Contact Section
              ContactSection(settings: _settings),

              // Footer with legal links
              const FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}
