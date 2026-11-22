import 'package:flutter_test/flutter_test.dart';
import 'package:global_invoice/app/theme/app_theme.dart';

void main() {
  test('light and dark themes are configured', () {
    expect(AppTheme.light.useMaterial3, isTrue);
    expect(AppTheme.dark.useMaterial3, isTrue);
  });
}
