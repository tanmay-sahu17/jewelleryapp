import 'package:intl/intl.dart';

final NumberFormat _rupeeFormatter = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
);

String formatRupee(double value, {String suffix = ''}) {
  return '${_rupeeFormatter.format(value)}$suffix';
}

String formatWeight(double value) {
  return '${value.toStringAsFixed(1)}g';
}

String cleanPhone(String value) {
  return value.replaceAll(RegExp(r'[^0-9]'), '');
}
