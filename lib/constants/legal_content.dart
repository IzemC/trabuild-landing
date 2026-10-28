/// Static copy for the legal pages linked from the footer.
///
/// The wording is taken verbatim from the approved TRABUILD LTD documents.
class LegalSection {
  final String? heading;
  final List<String> paragraphs;

  const LegalSection({this.heading, required this.paragraphs});
}

class LegalDocument {
  final String title;
  final String? lastUpdated;
  final List<LegalSection> sections;

  const LegalDocument({
    required this.title,
    this.lastUpdated,
    required this.sections,
  });
}

class LegalContent {
  LegalContent._();

  static const String companyNumber = '17508463';
  static const String registeredOffice =
      'Flat 15 Aneurin Bevan Court, 55 Coles Green Road, London, NW2 6EE, '
      'United Kingdom';
  static const String contactEmail = 'trabuild@gmail.com';

  static const LegalDocument aboutUs = LegalDocument(
    title: 'About Us',
    sections: [
      LegalSection(
        paragraphs: [
          'TRABUILD is an education and technology platform providing '
              'practical courses, digital tools, and learning resources for '
              'architects, engineers, and students. Our mission is to make '
              'professional knowledge more accessible and help our community '
              'develop skills, improve workflows, and explore new '
              'possibilities in design and engineering.',
          'The platform is operated by TRABUILD LTD, a private limited '
              'company registered in England and Wales, United Kingdom, under '
              'company number $companyNumber.',
          'Registered office: $registeredOffice.',
          'Contact: $contactEmail',
        ],
      ),
    ],
  );

  static const LegalDocument privacyPolicy = LegalDocument(
    title: 'Privacy Policy',
    lastUpdated: 'Last updated: 12 October 2026',
    sections: [
      LegalSection(
        paragraphs: [
          'TRABUILD LTD is responsible for the personal information processed '
              'through our website and digital services. Our registered '
              'company details are provided in the About Us section.',
        ],
      ),
      LegalSection(
        heading: 'Information and purposes',
        paragraphs: [
          'Depending on the services you use, we process information you '
              'provide, such as your name, email address, account details, '
              'orders, and correspondence, together with relevant technical '
              'information generated through platform use. We use this '
              'information to respond to enquiries, deliver services, '
              'administer purchases, provide support, and protect our '
              'platform.',
          'Our legal bases are performing our contracts, meeting legal '
              'obligations, our legitimate interests in operating secure and '
              'reliable services, and consent where required.',
        ],
      ),
      LegalSection(
        heading: 'Sharing and international processing',
        paragraphs: [
          'Relevant information may be shared with providers supporting '
              'hosting, course delivery, communications, and payments, or '
              'with authorities where legally required. Restricted transfers '
              'outside the United Kingdom must be covered by an applicable '
              'lawful transfer mechanism. Information about relevant transfer '
              'arrangements is available by contacting us.',
        ],
      ),
      LegalSection(
        heading: 'Retention and security',
        paragraphs: [
          'We retain information according to the duration of your account '
              'and purchased access, the time needed to resolve enquiries, '
              'applicable record-keeping obligations, and the handling of '
              'legal claims. We apply appropriate security measures and '
              'delete or anonymise information when it is no longer required.',
        ],
      ),
      LegalSection(
        heading: 'Cookies and marketing',
        paragraphs: [
          'Where cookies or similar technologies require consent, we request '
              'it before use. You may withdraw consent and unsubscribe from '
              'marketing communications at any time. Essential service '
              'communications are handled separately from marketing.',
        ],
      ),
      LegalSection(
        heading: 'Your rights and complaints',
        paragraphs: [
          'Where applicable, you may request access, correction, deletion, '
              'restriction, or portability of your information, and object to '
              'processing. You may object to direct marketing at any time. '
              'Contact $contactEmail to exercise your rights or raise a '
              'privacy concern. You may also complain to the UK Information '
              "Commissioner's Office (ICO).",
        ],
      ),
      LegalSection(
        paragraphs: [
          'We may update this policy to reflect changes in our services or '
              'processing practices, providing additional notice where '
              'required.',
        ],
      ),
    ],
  );

  static const LegalDocument termsAndConditions = LegalDocument(
    title: 'Terms & Conditions',
    lastUpdated: 'Last updated: 12 October 2026',
    sections: [
      LegalSection(
        paragraphs: [
          'These Terms govern the use of the TRABUILD website and digital '
              'services supplied by TRABUILD LTD. Please read them before '
              'registering or purchasing.',
        ],
      ),
      LegalSection(
        heading: 'Accounts and access',
        paragraphs: [
          'You must provide accurate information and protect your login '
              'credentials. Access is personal unless a multi-user licence is '
              'expressly provided. Unauthorised account sharing, resale, or '
              'interference with platform security is prohibited.',
        ],
      ),
      LegalSection(
        heading: 'Purchases',
        paragraphs: [
          'Prices, applicable taxes, access periods, and technical '
              'requirements will be disclosed before payment. Any recurring '
              'charges require clear prior agreement. Your purchase is '
              'governed by these Terms and the product information provided '
              'before checkout.',
        ],
      ),
      LegalSection(
        heading: 'Intellectual property',
        paragraphs: [
          'Course materials, software, digital resources, and branding remain '
              'the property of TRABUILD or their respective owners. '
              'Unauthorised copying, redistribution, or resale is prohibited, '
              'except as permitted by law. Product-specific licences '
              'determine how supplied tools and assets may be used. You may '
              'apply the knowledge and skills you learn in your professional '
              'work.',
        ],
      ),
      LegalSection(
        heading: 'Cancellation and refunds',
        paragraphs: [
          'Where UK statutory cancellation rights apply to a digital-content '
              'purchase, you normally have 14 days from entering into the '
              'contract to cancel.',
          'This cancellation right ends when digital supply begins only where '
              'you have expressly consented to early supply, acknowledged the '
              'loss of that right, and received the required confirmation. '
              'Your rights concerning faulty, misdescribed, or undelivered '
              'content remain unaffected. To cancel or request assistance, '
              'contact $contactEmail with your order details. Refunds '
              'required by law will be processed within the applicable '
              'statutory timeframe.',
        ],
      ),
      LegalSection(
        heading: 'Educational scope and responsibility',
        paragraphs: [
          'Our courses and tools support learning and professional '
              'development; they do not replace project-specific professional '
              'judgement or required regulatory approvals. We do not '
              'guarantee employment, income, or particular project outcomes. '
              'Nothing in these Terms excludes liability that cannot lawfully '
              'be excluded or limits your statutory consumer rights.',
        ],
      ),
      LegalSection(
        heading: 'Changes and governing law',
        paragraphs: [
          'Updates to these Terms will not retrospectively reduce rights '
              'attached to existing purchases. These Terms are governed by '
              'the laws of England and Wales, without overriding mandatory '
              'consumer protections or court rights that apply in your '
              'country of residence.',
        ],
      ),
      LegalSection(
        paragraphs: [
          'Questions or complaints: $contactEmail',
        ],
      ),
    ],
  );
}
