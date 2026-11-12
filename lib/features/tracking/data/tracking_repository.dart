import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'tracking_models.dart';

/// Reads/writes mood check-ins and completed-exercise history to local
/// device storage. There's no user-account system yet (only the admin
/// login for managing exercises), so this data is local-only - it won't
/// sync across devices until real per-user accounts exist.
class TrackingRepository {
  final SharedPreferences _prefs;

  TrackingRepository(this._prefs);

  static const _checkInsKey = 'mood_checkins';
  static const _completedKey = 'completed_exercises';

  List<MoodCheckIn> getCheckIns() {
    final raw = _prefs.getString(_checkInsKey);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => MoodCheckIn.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCheckIns(List<MoodCheckIn> checkIns) async {
    final encoded = jsonEncode(checkIns.map((c) => c.toJson()).toList());
    await _prefs.setString(_checkInsKey, encoded);
  }

  List<CompletedExercise> getCompletedExercises() {
    final raw = _prefs.getString(_completedKey);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => CompletedExercise.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCompletedExercises(List<CompletedExercise> completed) async {
    final encoded = jsonEncode(completed.map((c) => c.toJson()).toList());
    await _prefs.setString(_completedKey, encoded);
  }
}
