import 'package:flutter/widgets.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:super_dash/app/app.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/settings/persistence/persistence.dart';
import 'package:super_dash/settings/settings.dart';
import 'package:super_dash/share/share.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsController(
    persistence: LocalStorageSettingsPersistence(),
  );

  final audio = AudioController()..attachSettings(settings);
  await audio.initialize();

  runApp(
    App(
      audioController: audio,
      settingsController: settings,
      shareController: ShareController(
        gameUrl: 'https://github.com/g-ai-002/flutter-super-dash',
      ),
      leaderboardRepository: LeaderboardRepository(),
    ),
  );
}
