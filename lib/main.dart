import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:landing/constants/legal_content.dart';
import 'package:landing/landing_page.dart';
import 'package:landing/pages/legal_page.dart';
import 'package:landing/pages/reset_password_page.dart';

void main() {
  // Serve real paths (/privacy, /reset-password) instead of hash fragments —
  // the backend emails path-style links and the stores need a public URL for
  // the privacy policy. nginx already falls back to index.html for all routes.
  usePathUrlStrategy();
  runApp(const TrabuildLandingApp());
}

class TrabuildLandingApp extends StatelessWidget {
  const TrabuildLandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRABUILD - Studio for Architect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0E7490),
          secondary: Color(0xFF0E7490),
          surface: Color(0xFF000000),
          background: Color(0xFF000000),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '/');

        if (uri.path == '/reset-password') {
          final token = uri.queryParameters['token'] ?? '';
          return MaterialPageRoute(
            builder: (_) => ResetPasswordPage(token: token),
          );
        }

        final legalDocument = _legalDocuments[uri.path];
        if (legalDocument != null) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => LegalPage(document: legalDocument),
          );
        }

        return MaterialPageRoute(
          builder: (_) => const LandingPage(),
        );
      },
    );
  }
}

const Map<String, LegalDocument> _legalDocuments = {
  '/about': LegalContent.aboutUs,
  '/privacy': LegalContent.privacyPolicy,
  '/terms': LegalContent.termsAndConditions,
};
