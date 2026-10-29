# Super Dash 🏃

横版跑酷游戏，基于 Flutter + Flame 引擎开发，支持 Android、Windows 与 Web 三平台。

源码移植自 [flutter-team-archive/super_dash](https://github.com/flutter-team-archive/super_dash)，
并按照本仓库群的既有基线（Flutter 3.47.8 / Flame 1.38.2 / 双流水线发布）完成平台裁剪与现代化改造。

## 功能

- 🎮 横版自动跑酷：跳跃、二段跳、滑铲与边缘抓取
- 🗺️ 三张 Tiled 地图循环切换，含地形、坡道与过关传送门
- 🥚 收集橡果、蛋与金色羽毛，羽毛提供一次免死与凤凰形态
- 🐝 多种敌人（甲虫、蜜蜂、蝴蝶、蚱蜢、蚂蚁、蜻蜓）与巡逻路径
- 💥 受伤/落坑死亡动画、镜头跟随与过关计分
- 🏆 本地排行榜：前十名成绩持久化（SharedPreferences）
- 📊 分数结算、首字母输入与排行榜页面
- 🎵 背景音乐与音效，可在设置中开关
- 🌐 简体中文 / 英文界面（Flutter gen-l10n）
- ⌨️ 桌面端空格跳跃 + 点击/触摸跳跃
- 🖥️ 自适应布局，支持手机、桌面与浏览器

## 开发

### 环境要求

- Flutter 3.47.8+（内置 Dart 3.13.7+）
- Android SDK 37+（编译 SDK；最低支持 Android 15）
- Windows 10+（构建 Windows 桌面版）

### 运行

```bash
flutter pub get
flutter run
```

### 测试

```bash
flutter test
```

### 平台文件

`android/` 随仓库提交；`web/` 与 `windows/` 由 CI 在构建时生成，本地预览前先执行：

```bash
flutter create --platforms=web --project-name flutter_super_dash .
flutter create --platforms=windows --project-name flutter_super_dash .
```

### 发布

推送 `v*` 标签会触发 GitHub Actions 与 Gitea Actions 双流水线，分别构建 Android APK、
Windows ZIP 与 Web 产物，并在对应平台自动创建 Release：

```bash
git tag v0.1.0
git push origin v0.1.0
```

GitHub Pages 会为每个版本保留独立目录（`v0.1.0/` …），非 tag 构建写入 `debug/`，
根目录自动生成版本索引页与 `versions.json`。

## 技术栈

- Flutter 3.47.8
- Flame 1.38.2（游戏循环、相机、精灵动画）
- Leap 0.7.0（平台跳跃物理与 Tiled 地图加载）
- flutter_bloc 状态管理
- SharedPreferences 本地持久化
- audioplayers 音频播放
- Web：GitHub Pages 多版本在线试玩

## 许可证

BSD-3-Clause，见 [LICENSE](LICENSE)。
