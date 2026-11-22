import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('basic Flutter text renders', (tester) async {
    await tester.pumpWidget(const Directionality(
      textDirection: TextDirection.ltr,
      child: Text('Global Invoice'),
    ));
    expect(find.text('Global Invoice'), findsOneWidget);
  });
}
