# Super Dash — 项目规划

## 长期目标

- 跨 Android + Windows + Web 三平台的横版跑酷游戏
- 保留上游 `super_dash` 的玩法与美术，工程基线对齐本仓库群的既有约定
- 每个版本可独立交付，可观测、可回滚

## 中期目标

- [x] 移植上游 `flutter-team-archive/super_dash` 源码
- [x] 只保留 Android / Windows / Web 三个平台
- [x] 依赖版本与 Flutter / Android 构建链对齐 `flutter-snake`
- [x] GitHub Actions 与 Gitea Actions 双流水线
- [x] 本地排行榜（移除 Firebase，改用 SharedPreferences）
- [x] 单元测试与 Widget 测试通过
- [ ] 首次发布 `v0.1.0`

## 版本历史

### v0.1.0 (MINOR)

- **状态**: 开发完成 ✅，待发布
- **目标**: 从上游 `super_dash` 移植并完成三平台与工程基线改造
- **任务**:
  - [x] 复制上游 `lib/`、`test/`、`packages/`、`assets/` 与 l10n 配置
  - [x] 删除 iOS / macOS / Firebase Functions 等非目标平台与云能力
  - [x] 升级到 Flutter 3.47.8 / Dart 3.13.7，Flame 1.38.2，audioplayers 6.8.1
  - [x] Leap 0.7.0 + flame_tiled 1.21.2 + flame_behaviors 1.4.0 适配
  - [x] `gameRef` / `CollisionType` / `otherCollisions` / `OrderedSet` / 手势与键盘 API 迁移
  - [x] 移除 `font_awesome_flutter`，改用 Material 图标
  - [x] 移除 Firebase 与匿名登录，排行榜改为本地持久化
  - [x] l10n 从合成包迁移到 `lib/l10n/generated`
  - [x] Android 工程、签名、Gradle 构建链对齐 `flutter-snake`
  - [x] GitHub Actions / Gitea Actions 双流水线（Android / Windows / Web）
  - [x] README、LICENSE、plan 文档

## 设计原则

- **离线优先**：排行榜与设置全部本地存储，不依赖网络。
- **平台克制**：只维护 Android、Windows、Web 三套平台文件。
- **基线一致**：依赖版本、Android 构建链、CI 工作流与 `flutter-snake` 保持一致。
- **可验证**：本地至少通过 `flutter analyze`、`flutter test` 与 `flutter build web`。

## 依赖与版本基线

- Flutter: 3.47.8
- Dart: 3.13.7（对应 Flutter 3.47.8 内置 Dart SDK）
- Android SDK: compileSdk=37.2 / targetSdk=37 / minSdk=35，NDK 30.0.16248370
- flame: 1.38.2
- leap: 0.7.0
- flame_tiled: 1.21.2
- flame_behaviors: 1.4.0
- audioplayers: 6.8.1
- provider: 6.1.5+1
- shared_preferences: 2.5.6
- path_provider: 2.1.6
- path: 1.9.1
- window_manager: 0.5.2
- flutter_lints: 6.0.0
