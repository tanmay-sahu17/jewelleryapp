import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'formatters.dart';

class LauncherUtils {
  static Future<void> call(BuildContext context, String phoneNumber) async {
    final Uri uri = Uri.parse('tel:${cleanPhone(phoneNumber)}');
    await _launch(
      context,
      uri,
      fallbackMessage: 'Unable to open dialer right now.',
    );
  }

  static Future<void> email(BuildContext context, String email) async {
    final Uri uri = Uri.parse('mailto:$email');
    await _launch(
      context,
      uri,
      fallbackMessage: 'Unable to open email app right now.',
    );
  }

  static Future<void> whatsapp(
    BuildContext context, {
    required String phoneNumber,
    required String message,
  }) async {
    final String phone = cleanPhone(phoneNumber);
    final Uri uri = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );
    await _launch(
      context,
      uri,
      fallbackMessage: 'Unable to open WhatsApp. Please try again later.',
      mode: LaunchMode.externalApplication,
    );
  }

  static Future<void> _launch(
    BuildContext context,
    Uri uri, {
    required String fallbackMessage,
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    final bool success = await launchUrl(uri, mode: mode);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(fallbackMessage)));
    }
  }
}
