// task_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finden_test/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const testEmail = 'test@example.com';
  const testPassword = 'Test1234!';

  group('Task Management Flow', () {
    testWidgets('Full user flow from login to task management',
        (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Initial cleanup: Sign out if already logged in
      try {
        final logoutButton = find.text('Logout');
        await tester.tap(logoutButton);
        await tester.pumpAndSettle();
      } catch (e) {
        print('No user logged in');
      }

      // Sign up
      await tester.tap(find.text('Need an account? Sign Up'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), testEmail);
      await tester.enterText(find.byType(TextField).at(1), testPassword);
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Verify we're on the task list
      expect(find.text('Tasks'), findsOneWidget);

      // Create new task
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Fill task details
      await tester.enterText(find.byType(TextField).at(0), 'Test Task');
      await tester.enterText(find.byType(TextField).at(1), 'Test Description');
      await tester.tap(find.text('Due:'));
      await tester.pumpAndSettle();

      // Select date and time
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Save task
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Verify task in list
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);

      // Edit task
      await tester.tap(find.text('Test Task'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'Updated Task');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Updated Task'), findsOneWidget);

      // Mark as completed
      final checkbox = find.byType(Checkbox).first;
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
      expect(tester.widget<Checkbox>(checkbox).value, true);

      // Delete task
      final taskCard = find.byType(Dismissible).first;
      await tester.drag(taskCard, Offset(-500.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.text('Updated Task'), findsNothing);

      // Undo deletion
      await tester.tap(find.byIcon(Icons.undo));
      await tester.pumpAndSettle();
      expect(find.text('Updated Task'), findsOneWidget);

      // Test theme toggle
      final themeButton = find.byIcon(Icons.dark_mode);
      await tester.tap(themeButton);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.light_mode), findsOneWidget);

      // Test search
      await tester.enterText(find.byType(TextField).first, 'Updated');
      await tester.pumpAndSettle();
      expect(find.text('Updated Task'), findsOneWidget);

      // Clear search
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pumpAndSettle();

      // Test filter
      await tester.tap(find.text('Priority'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Medium').last);
      await tester.pumpAndSettle();
      expect(find.text('Updated Task'), findsOneWidget);

      // Sign out
      final menuButton = find.byTooltip('Back');
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
      expect(find.text('Task Manager Login'), findsOneWidget);
    });
  });
}