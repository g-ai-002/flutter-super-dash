import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LeaderboardRepository', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('can be instantiated', () {
      expect(LeaderboardRepository(), isNotNull);
    });

    group('fetchTop10Leaderboard', () {
      test('returns an empty list when there is no stored data', () async {
        final leaderboard =
            await LeaderboardRepository().fetchTop10Leaderboard();

        expect(leaderboard, isEmpty);
      });

      test('returns entries sorted by score', () async {
        final repository = LeaderboardRepository();
        await repository.addLeaderboardEntry(
          const LeaderboardEntryData(score: 100, playerInitials: 'AAA'),
        );
        await repository.addLeaderboardEntry(
          const LeaderboardEntryData(score: 2500, playerInitials: 'BBB'),
        );
        await repository.addLeaderboardEntry(
          const LeaderboardEntryData(score: 600, playerInitials: 'CCC'),
        );

        final leaderboard = await repository.fetchTop10Leaderboard();

        expect(
          leaderboard.map((entry) => entry.score),
          equals([2500, 600, 100]),
        );
      });

      test('returns at most the top 10 entries', () async {
        final repository = LeaderboardRepository();
        for (var score = 1; score <= 12; score++) {
          await repository.addLeaderboardEntry(
            LeaderboardEntryData(score: score, playerInitials: 'ABC'),
          );
        }

        final leaderboard = await repository.fetchTop10Leaderboard();

        expect(leaderboard, hasLength(10));
        expect(leaderboard.first.score, equals(12));
        expect(leaderboard.last.score, equals(3));
      });

      test(
          'throws LeaderboardDeserializationException when the stored data '
          'is malformed', () async {
        SharedPreferences.setMockInitialValues({
          'leaderboardEntries': jsonEncode([
            {'playerInitials': 'ABC'},
          ]),
        });

        expect(
          () => LeaderboardRepository().fetchTop10Leaderboard(),
          throwsA(isA<LeaderboardDeserializationException>()),
        );
      });

      test(
          'throws FetchTop10LeaderboardException when the stored data '
          'is not valid JSON', () async {
        SharedPreferences.setMockInitialValues({
          'leaderboardEntries': 'not-json',
        });

        expect(
          () => LeaderboardRepository().fetchTop10Leaderboard(),
          throwsA(isA<FetchTop10LeaderboardException>()),
        );
      });
    });

    group('addLeaderboardEntry', () {
      test('keeps only the top 10 scores', () async {
        final repository = LeaderboardRepository();
        for (var score = 1; score <= 10; score++) {
          await repository.addLeaderboardEntry(
            LeaderboardEntryData(score: score, playerInitials: 'ABC'),
          );
        }

        await repository.addLeaderboardEntry(
          const LeaderboardEntryData(score: 100, playerInitials: 'NEW'),
        );

        final leaderboard = await repository.fetchTop10Leaderboard();

        expect(leaderboard, hasLength(10));
        expect(leaderboard.first.playerInitials, equals('NEW'));
        expect(leaderboard.map((entry) => entry.score), isNot(contains(1)));
      });

      test('does not save a score lower than the top 10', () async {
        final repository = LeaderboardRepository();
        for (var score = 11; score <= 20; score++) {
          await repository.addLeaderboardEntry(
            LeaderboardEntryData(score: score, playerInitials: 'ABC'),
          );
        }

        await repository.addLeaderboardEntry(
          const LeaderboardEntryData(score: 5, playerInitials: 'LOW'),
        );

        final leaderboard = await repository.fetchTop10Leaderboard();

        expect(
          leaderboard.map((entry) => entry.playerInitials),
          isNot(contains('LOW')),
        );
      });
    });
  });
}
