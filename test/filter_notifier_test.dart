
import 'package:flutter_test/flutter_test.dart';
import 'package:finden_test/application/providers.dart';
import 'package:finden_test/domain/value_objects/priority.dart';
void main() {
  group('FilterNotifier', () {
    test('Initial state is empty', () {
      final notifier = FilterNotifier();
      expect(notifier.state.searchQuery, '');
      expect(notifier.state.priority, isNull);
      expect(notifier.state.isCompleted, isNull);
    });

    test('updateSearchQuery updates state', () {
      final notifier = FilterNotifier();
      notifier.updateSearchQuery('test');
      expect(notifier.state.searchQuery, 'test');
    });

    test('updatePriority updates state', () {
      final notifier = FilterNotifier();
      notifier.updatePriority(Priority.high);
      expect(notifier.state.priority, Priority.high);
    });

    test('updateIsCompleted updates state', () {
      final notifier = FilterNotifier();
      notifier.updateIsCompleted(true);
      expect(notifier.state.isCompleted, true);
    });
  });
}