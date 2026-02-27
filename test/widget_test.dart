import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/providers/app_provider.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    final provider = AppProvider();
    await tester.pumpWidget(HabitTrackerApp(provider: provider));
    // Verify login screen renders
    expect(find.text('Weworksense'), findsOneWidget);
  });
}
