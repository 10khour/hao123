import 'dart:io';

import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

class AppWindowLisenter extends WindowListener {
  // 监听程序关闭事件
  @override
  void onWindowClose() {
    super.onWindowClose();
    windowManager.minimize();
  }
}

Future<void> initSystemTray() async {
  String path = 'assets/123.png';

  final AppWindow appWindow = AppWindow();
  final SystemTray systemTray = SystemTray();

  // We first init the systray menu
  await systemTray.initSystemTray(
    iconPath: path,
  );

  // create context menu
  final Menu menu = Menu();
  await menu.buildFrom([
    MenuItemLabel(label: 'Exit', onClicked: (menuItem) => exit(0)),
  ]);

  // set context menu
  await systemTray.setContextMenu(menu);

  // handle system tray event
  systemTray.registerSystemTrayEventHandler((eventName) async {
    // debugPrint("eventName: $eventName");
    if (eventName == kSystemTrayEventClick) {
      if (await windowManager.isMinimized()) {
        Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
      } else {
        Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.close();
      }
    } else {
      if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
      }
    }
  });
}

WindowOptions windowOptions = const WindowOptions(
  size: Size(1350, 850),
  center: true,
  backgroundColor: Colors.transparent,
  skipTaskbar: false,
  titleBarStyle: TitleBarStyle.hidden,
  windowButtonVisibility: true,
);

initWindow() async {
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show(inactive: true);
    await windowManager.focus();
  });
}

appBarDoubleTap() async {
  if (await windowManager.isMaximized()) {
    await initWindow();
    windowManager.center();
  } else {
    await windowManager.maximize();
  }
}
