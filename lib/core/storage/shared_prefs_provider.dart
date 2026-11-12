import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in `main()` with a real [SharedPreferences] instance once
/// `SharedPreferences.getInstance()` has resolved (see main.dart). Reading
/// this before that override is applied is a programming error, hence the
/// throw - it should never happen in practice since main() awaits it
/// before building the widget tree.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main() with a real '
    'SharedPreferences instance.',
  );
});
