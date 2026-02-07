import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, String?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      var id = prefs.getString('user_id');
      if (id == null) {
        id = const Uuid().v4();
        await prefs.setString('user_id', id);
      }
      return id;
    });
  }
}
