import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landing/constants/app_colors.dart';
import 'package:landing/constants/legal_content.dart';

/// Renders a static legal document (About Us, Privacy Policy, Terms).
class LegalPage extends StatelessWidget {
  final LegalDocument document;

  const LegalPage({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: isMobile ? 28 : 40),

            // Logo doubles as the way back to the landing page
            _HomeLogo(isMobile: isMobile),
            SizedBox(height: isMobile ? 20 : 28),

            Divider(
              color: AppColors.grey.withOpacity(0.4),
              height: 1,
              thickness: 1,
              indent: isMobile ? 20 : 80,
              endIndent: isMobile ? 20 : 80,
            ),
            SizedBox(height: isMobile ? 36 : 56),

            Text(
              document.title,
              style: TextStyle(
                color: AppColors.white,
                fontSize: isMobile ? 26 : 34,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isMobile ? 28 : 44),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildBody(isMobile),
                ),
              ),
            ),

            SizedBox(height: isMobile ? 56 : 88),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBody(bool isMobile) {
    final widgets = <Widget>[];

    if (document.lastUpdated != null) {
      widgets.add(
        Text(
          document.lastUpdated!,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: isMobile ? 13 : 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      );
      widgets.add(SizedBox(height: isMobile ? 24 : 32));
    }

    for (var i = 0; i < document.sections.length; i++) {
      final section = document.sections[i];

      if (i > 0) {
        widgets.add(SizedBox(height: isMobile ? 24 : 28));
      }

      if (section.heading != null) {
        widgets.add(
          Text(
            section.heading!,
            style: TextStyle(
              color: AppColors.white,
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        );
        widgets.add(const SizedBox(height: 10));
      }

      for (var j = 0; j < section.paragraphs.length; j++) {
        if (j > 0) {
          widgets.add(const SizedBox(height: 14));
        }
        widgets.add(
          Text(
            section.paragraphs[j],
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: isMobile ? 14 : 15,
              fontWeight: FontWeight.w400,
              height: 1.7,
            ),
          ),
        );
      }
    }

    return widgets;
  }
}

class _HomeLogo extends StatelessWidget {
  final bool isMobile;

  const _HomeLogo({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacementNamed('/');
          }
        },
        child: Semantics(
          button: true,
          label: 'TRABUILD home',
          child: SvgPicture.asset(
            'assets/images/trabuild.svg',
            height: isMobile ? 26 : 34,
          ),
        ),
      ),
    );
  }
}
