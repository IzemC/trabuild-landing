import 'package:flutter/material.dart';
import 'package:landing/constants/app_colors.dart';
import 'package:landing/constants/app_strings.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final divider = Divider(
      color: AppColors.grey.withOpacity(0.4),
      height: 1,
      thickness: 1,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: isMobile ? 20 : 80,
        right: isMobile ? 20 : 80,
        top: isMobile ? 24 : 32,
        bottom: isMobile ? 32 : 40,
      ),
      child: Column(
        children: [
          divider,

          // Legal links
          Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 10),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: isMobile ? 12 : 16,
              runSpacing: 8,
              children: [
                _FooterLink(
                  label: AppStrings.aboutUs,
                  routeName: '/about',
                  isMobile: isMobile,
                ),
                _FooterLinkSeparator(isMobile: isMobile),
                _FooterLink(
                  label: AppStrings.privacyPolicy,
                  routeName: '/privacy',
                  isMobile: isMobile,
                ),
                _FooterLinkSeparator(isMobile: isMobile),
                _FooterLink(
                  label: AppStrings.termsAndConditions,
                  routeName: '/terms',
                  isMobile: isMobile,
                ),
              ],
            ),
          ),

          divider,
          SizedBox(height: isMobile ? 20 : 24),

          // Company registration details
          _LegalLine(AppStrings.companyRegistration, isMobile: isMobile),
          const SizedBox(height: 4),
          _LegalLine(AppStrings.registeredOffice, isMobile: isMobile),
          const SizedBox(height: 4),
          _LegalLine(
            '© ${DateTime.now().year} TRABUILD LTD. All rights reserved.',
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }
}

class _LegalLine extends StatelessWidget {
  final String text;
  final bool isMobile;

  const _LegalLine(this.text, {required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.grey,
        fontSize: isMobile ? 12 : 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _FooterLinkSeparator extends StatelessWidget {
  final bool isMobile;

  const _FooterLinkSeparator({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Text(
      '|',
      style: TextStyle(
        color: AppColors.grey.withOpacity(0.6),
        fontSize: isMobile ? 13 : 14,
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final String routeName;
  final bool isMobile;

  const _FooterLink({
    required this.label,
    required this.routeName,
    required this.isMobile,
  });

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(widget.routeName),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: _isHovered ? AppColors.primary : AppColors.white,
            fontSize: widget.isMobile ? 13 : 14,
            fontWeight: FontWeight.w500,
            decoration:
                _isHovered ? TextDecoration.underline : TextDecoration.none,
            decorationColor: AppColors.primary,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
