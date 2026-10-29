import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_dash/app/app.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game_intro/game_intro.dart';
import 'package:super_dash/settings/settings.dart';
import 'package:super_dash/share/share.dart';

class _MockAudioController extends Mock implements AudioController {}

class _MockSettingsController extends Mock implements SettingsController {}

class _MockShareController extends Mock implements ShareController {}

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

void main() {
  group('App', () {
    late AudioController audioController;
    late SettingsController settingsController;
    late ShareController shareController;
    late LeaderboardRepository leaderboardRepository;

    setUp(() {
      audioController = _MockAudioController();
      settingsController = _MockSettingsController();
      shareController = _MockShareController();
      leaderboardRepository = _MockLeaderboardRepository();

      when(() => settingsController.muted).thenReturn(ValueNotifier(true));
    });

    testWidgets('renders GameIntroPage', (tester) async {
      await tester.pumpWidget(
        App(
          audioController: audioController,
          settingsController: settingsController,
          shareController: shareController,
          leaderboardRepository: leaderboardRepository,
        ),
      );
      expect(find.byType(GameIntroPage), findsOneWidget);
    });
  });
}
