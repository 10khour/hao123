import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hao123/hao123.dart';
import 'package:hao123/windows.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  // 桌面端逻辑
  if ((!kIsWeb) &&
      (Platform.isLinux || Platform.isMacOS || Platform.isWindows)) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    // 允许最小化
    await windowManager.setMinimizable(true);
    // 拦截程序关闭按键
    await windowManager.setPreventClose(true);
    // 状态托盘
    await initSystemTray();
    // 添加窗口事件监听者
    windowManager.addListener(AppWindowLisenter());

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1350, 850),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: true,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, title: 'hao123', home: Hao123());
  }
}
