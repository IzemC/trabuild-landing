import 'package:flutter/material.dart';
import 'package:landing/constants/app_colors.dart';
import 'package:landing/constants/app_strings.dart';
import 'package:landing/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatefulWidget {
  final LandingSettings settings;

  const ContactSection({super.key, required this.settings});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;
  String? _successMessage;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _successMessage = null;
      _errorMessage = null;
    });

    final response = await ApiService().submitContact(
      email: _emailController.text.trim(),
      message: _messageController.text.trim(),
      name: _nameController.text.trim(),
    );

    setState(() {
      _isSubmitting = false;
      if (response.success) {
        _successMessage = response.message;
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      } else {
        _errorMessage = response.message;
      }
    });
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
      child: Column(
        children: [
          // Contact us title
          Text(
            AppStrings.contactUs,
            style: TextStyle(
              color: AppColors.white,
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: isMobile ? 24 : 32),

          // Contact info
          if (isMobile)
            Column(
              children: [
                _ContactItem(
                  label: AppStrings.emailLabel,
                  value: widget.settings.contactEmail,
                  onTap: () => _launchEmail(),
                  isMobile: true,
                ),
                const SizedBox(height: 24),
                _ContactItem(
                  label: AppStrings.phoneLabel,
                  value: widget.settings.contactPhone,
                  onTap: () => _launchPhone(),
                  isMobile: true,
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ContactItem(
                  label: AppStrings.emailLabel,
                  value: widget.settings.contactEmail,
                  onTap: () => _launchEmail(),
                  isMobile: false,
                ),
                SizedBox(width: isTablet ? 60 : 120),
                _ContactItem(
                  label: AppStrings.phoneLabel,
                  value: widget.settings.contactPhone,
                  onTap: () => _launchPhone(),
                  isMobile: false,
                ),
              ],
            ),

          SizedBox(height: isMobile ? 40 : 56),

          // Contact Form
          Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: _buildContactForm(isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm(bool isMobile) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Send us a message',
            style: TextStyle(
              color: AppColors.white,
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Name field
          _buildTextField(
            controller: _nameController,
            label: 'Your Name',
            validator: (value) => null, // Optional field
          ),
          const SizedBox(height: 16),

          // Email field
          _buildTextField(
            controller: _emailController,
            label: 'Email *',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Message field
          _buildTextField(
            controller: _messageController,
            label: 'Message *',
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Message is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Success/Error messages
          if (_successMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                _successMessage!,
                style: const TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              ),
            ),
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),

          // Submit button
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.grey.withOpacity(0.8)),
        filled: true,
        fillColor: AppColors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  void _launchEmail() async {
    final Uri url = Uri.parse('mailto:${widget.settings.contactEmail}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchPhone() async {
    final Uri url = Uri.parse('tel:${widget.settings.contactPhone}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}

class _ContactItem extends StatefulWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isMobile;

  const _ContactItem({
    required this.label,
    required this.value,
    required this.onTap,
    required this.isMobile,
  });

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment:
              widget.isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: widget.isMobile ? 14 : 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: _isHovered ? AppColors.primary : AppColors.white,
                fontSize: widget.isMobile ? 16 : 18,
                fontWeight: FontWeight.w500,
                decoration: _isHovered ? TextDecoration.underline : TextDecoration.none,
              ),
              child: Text(widget.value),
            ),
          ],
        ),
      ),
    );
  }
}
