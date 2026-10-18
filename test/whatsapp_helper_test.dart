import 'package:flutter_test/flutter_test.dart';
import 'package:joblink_portal/utils/whatsapp_helper.dart';

void main() {
  group('formatPhoneForWhatsApp', () {
    test('formats local 11-digit phone number starting with 0', () {
      expect(formatPhoneForWhatsApp('03001234567'), equals('923001234567'));
    });

    test('formats formatted local phone number with dashes or spaces', () {
      expect(formatPhoneForWhatsApp('0300-123-4567'), equals('923001234567'));
      expect(formatPhoneForWhatsApp('0300 123 4567'), equals('923001234567'));
    });

    test('preserves international format starting with 92', () {
      expect(formatPhoneForWhatsApp('+923001234567'), equals('923001234567'));
      expect(formatPhoneForWhatsApp('923001234567'), equals('923001234567'));
    });

    test('handles 10-digit number without leading 0', () {
      expect(formatPhoneForWhatsApp('3001234567'), equals('923001234567'));
    });

    test('returns empty string for empty or invalid input', () {
      expect(formatPhoneForWhatsApp(''), equals(''));
      expect(formatPhoneForWhatsApp('abc'), equals(''));
    });
  });
}
