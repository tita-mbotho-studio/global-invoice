import 'package:decimal/decimal.dart';

/// Starter arithmetic only. Not a jurisdiction-specific tax engine.
class InvoiceLineInput {
  const InvoiceLineInput({required this.quantity, required this.unitPrice});
  final Decimal quantity;
  final Decimal unitPrice;
}

class InvoiceTotals {
  const InvoiceTotals({
    required this.subtotal,
    required this.tax,
    required this.total,
  });
  final Decimal subtotal;
  final Decimal tax;
  final Decimal total;
}

abstract final class InvoiceCalculator {
  static const _minorUnits = <String, int>{
    'JPY': 0, 'KRW': 0, 'CLP': 0,
    'KWD': 3, 'BHD': 3, 'OMR': 3,
  };

  static int fractionDigits(String currencyCode) {
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(currencyCode)) {
      throw ArgumentError.value(currencyCode, 'currencyCode', 'Expected 3 uppercase letters');
    }
    // TODO: replace with an audited ISO 4217 currency table.
    return _minorUnits[currencyCode] ?? 2;
  }

  static InvoiceTotals calculate({
    required String currencyCode,
    required List<InvoiceLineInput> lines,
    Decimal taxRatePercent = Decimal.zero,
  }) {
    if (lines.isEmpty) throw ArgumentError('At least one line is required');
    if (taxRatePercent < Decimal.zero || taxRatePercent > Decimal.fromInt(100)) {
      throw ArgumentError.value(taxRatePercent, 'taxRatePercent', 'Expected 0 to 100');
    }
    final digits = fractionDigits(currencyCode);
    var subtotal = Decimal.zero;
    for (final line in lines) {
      if (line.quantity <= Decimal.zero || line.unitPrice < Decimal.zero) {
        throw ArgumentError('Quantity must be positive and price nonnegative');
      }
      subtotal += (line.quantity * line.unitPrice).round(scale: digits);
    }
    final tax = (subtotal * taxRatePercent * Decimal.parse('0.01')).round(scale: digits);
    return InvoiceTotals(subtotal: subtotal, tax: tax, total: subtotal + tax);
  }
}
