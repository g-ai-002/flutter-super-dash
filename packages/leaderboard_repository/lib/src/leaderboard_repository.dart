import 'dart:convert';

import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template leaderboard_repository}
/// Repository to persist and read the local leaderboard data.
/// {@endtemplate}
class LeaderboardRepository {
  /// {@macro leaderboard_repository}
  LeaderboardRepository({SharedPreferences? preferences})
      : _preferences = preferences;

  final SharedPreferences? _preferences;

  static const _leaderboardLimit = 10;
  static const _storageKey = 'leaderboardEntries';

  Future<SharedPreferences> get _prefs async =>
      _preferences ?? await SharedPreferences.getInstance();

  /// Acquires top 10 [LeaderboardEntryData]s.
  Future<List<LeaderboardEntryData>> fetchTop10Leaderboard() async {
    try {
      final entries = await _readAllSorted();
      return entries.take(_leaderboardLimit).toList();
    } on LeaderboardDeserializationException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      throw FetchTop10LeaderboardException(error, stackTrace);
    }
  }

  /// Adds player's score entry to the leaderboard if it is within the top-10
  Future<void> addLeaderboardEntry(
    LeaderboardEntryData entry,
  ) async {
    final leaderboard = await _readAllSorted()
      ..add(entry)
      ..sort((a, b) => b.score.compareTo(a.score));

    try {
      final prefs = await _prefs;
      final json = jsonEncode(
        leaderboard
            .take(_leaderboardLimit)
            .map((entry) => entry.toJson())
            .toList(),
      );
      await prefs.setString(_storageKey, json);
    } on Exception catch (error, stackTrace) {
      throw AddLeaderboardEntryException(error, stackTrace);
    }
  }

  Future<List<LeaderboardEntryData>> _readAllSorted() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) return <LeaderboardEntryData>[];

      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((entry) {
        try {
          return LeaderboardEntryData.fromJson(
            entry as Map<String, dynamic>,
          );
        } catch (error, stackTrace) {
          throw LeaderboardDeserializationException(error, stackTrace);
        }
      }).toList()
        ..sort((a, b) => b.score.compareTo(a.score));
    } on LeaderboardDeserializationException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      throw FetchLeaderboardException(error, stackTrace);
    }
  }
}
