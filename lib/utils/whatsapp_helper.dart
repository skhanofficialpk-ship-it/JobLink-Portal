import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Cleans non-digits and formats phone number into international format.
/// Defaults to Pakistan country code (92) if local format (e.g. 03xxxxxxxx) is provided.
String formatPhoneForWhatsApp(String phone) {
  String cleaned = phone.replaceAll(RegExp(r'\D'), '');
  if (cleaned.isEmpty) return '';

  if (cleaned.startsWith('0')) {
    cleaned = '92${cleaned.substring(1)}';
  } else if (!cleaned.startsWith('92') && cleaned.length == 10) {
    cleaned = '92$cleaned';
  }
  return cleaned;
}

/// Directly opens WhatsApp chat with the specified phone number.
Future<void> launchWhatsApp(BuildContext context, String phone) async {
  String formattedNumber = formatPhoneForWhatsApp(phone);
  if (formattedNumber.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid contact number for WhatsApp"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return;
  }

  final Uri whatsappUrl = Uri.parse("https://wa.me/$formattedNumber");
  try {
    if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not launch WhatsApp. Please check if WhatsApp is installed."),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not launch WhatsApp: $e"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
