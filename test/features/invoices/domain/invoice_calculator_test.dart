import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_invoice/features/invoices/domain/invoice_calculator.dart';

void main() {
  final d = Decimal.parse;

  test('decimal addition avoids binary floating-point drift', () {
    final result = InvoiceCalculator.calculate(currencyCode: 'USD', lines: [
      InvoiceLineInput(quantity: d('1'), unitPrice: d('0.10')),
      InvoiceLineInput(quantity: d('1'), unitPrice: d('0.20')),
    ]);
    expect(result.total, d('0.30'));
  });

  test('tax is rounded at currency scale', () {
    final result = InvoiceCalculator.calculate(
      currencyCode: 'USD',
      lines: [InvoiceLineInput(quantity: d('2'), unitPrice: d('19.99'))],
      taxRatePercent: d('10'),
    );
    expect(result.subtotal, d('39.98'));
    expect(result.tax, d('4.00'));
    expect(result.total, d('43.98'));
  });

  test('zero-decimal and three-decimal currencies', () {
    final jpy = InvoiceCalculator.calculate(
      currencyCode: 'JPY',
      lines: [InvoiceLineInput(quantity: d('1'), unitPrice: d('10.6'))],
    );
    final kwd = InvoiceCalculator.calculate(
      currencyCode: 'KWD',
      lines: [InvoiceLineInput(quantity: d('1'), unitPrice: d('1.2346'))],
    );
    expect(jpy.total, d('11'));
    expect(kwd.total, d('1.235'));
  });

  test('rejects invalid line values and tax rate', () {
    expect(() => InvoiceCalculator.calculate(
      currencyCode: 'USD',
      lines: [InvoiceLineInput(quantity: d('0'), unitPrice: d('1'))],
    ), throwsArgumentError);
    expect(() => InvoiceCalculator.calculate(
      currencyCode: 'USD',
      lines: [InvoiceLineInput(quantity: d('1'), unitPrice: d('1'))],
      taxRatePercent: d('101'),
    ), throwsArgumentError);
  });
}
