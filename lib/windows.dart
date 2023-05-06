import 'dart:developer';
import 'dart:io';

import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

class AppWindowLisenter extends WindowListener {
  @override
  void onWindowClose() {
    super.onWindowClose();
    log("close");
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
  systemTray.registerSystemTrayEventHandler((eventName) {
    // debugPrint("eventName: $eventName");
    if (eventName == kSystemTrayEventClick) {
      Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
    } else if (eventName == kSystemTrayEventRightClick) {
      Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
    }
  });
}
