import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vet_domi_ruta/main.dart';

void main() {
  testWidgets('VetDomiRutaApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: VetDomiRutaApp(),
      ),
    );
    expect(find.text('VetDomiRuta'), findsWidgets);
  });
}
