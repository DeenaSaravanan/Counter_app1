// providers/counter_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  Future<void> loadCounter(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('counters')
          .doc(userId)
          .get();

      if (doc.exists) {
        state = doc.data()?['value'] ?? 0;
      } else {
        state = 0;
      }
    } catch (e) {
      print('Error loading counter: $e');
    }
  }

  Future<void> increment(String userId) async {
    try {
      state = state + 1;
      await FirebaseFirestore.instance
          .collection('counters')
          .doc(userId)
          .set({'value': state});
    } catch (e) {
      print('Error incrementing counter: $e');
    }
  }
}
