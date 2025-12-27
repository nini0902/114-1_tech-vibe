import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_state.dart';

class StorageService {
  static const String _storageKey = 'tech_vibe_app_state';

  Future<AppState> loadAppState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null) {
        return AppState(); // 返回空狀態
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppState.fromJson(json);
    } catch (e) {
      print('Error loading app state: $e');
      return AppState();
    }
  }

  Future<void> saveAppState(AppState state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = state.toJson();
      final jsonString = jsonEncode(json);
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      print('Error saving app state: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing storage: $e');
    }
  }
}
